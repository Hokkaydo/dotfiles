from re import sub
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import time
import json

BASE_URL = "https://onderwijsaanbod.kuleuven.be"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (course-scraper)"
}

def get_soup(url):
    r = requests.get(url, headers=HEADERS, timeout=20)
    r.raise_for_status()
    return BeautifulSoup(r.text, "html.parser")


# ---------------------------
# PROGRAM PAGE PARSING
# ---------------------------

def extract_course_links(program_url):
    soup = get_soup(program_url)

    links = set()
    for a in soup.find_all("a", href=True):
        href = a["href"]
        full = urljoin(BASE_URL, href)

        if "onderwijsaanbod" in full and "syllabi" in full:
            links.add(full)
            print(f"Found {a.text}")
            if "ECS" in a.text:
                break

    return list(links)


# ---------------------------
# COURSE PAGE PARSING
# ---------------------------

def clean_text(el):
    if not el:
        return None
    return " ".join(el.get_text(" ", strip=True).split())


def extract_metadata(card):
    """Extract ECTS, language, type, hours, semester"""
    meta = {}

    legends = card.select(".activity-legend, .opo-legend")

    for l in legends:
        txt = clean_text(l)

        if not txt:
            continue

        if "ECTS" in txt:
            meta["ects"] = txt
        elif "hours" in txt:
            meta["hours"] = txt
        elif "English" in txt or "Dutch" in txt:
            meta["language"] = txt
        elif "semester" in txt:
            meta["semester"] = txt
        elif any(x in txt for x in ["Lecture", "Assignment", "Practical"]):
            meta["type"] = txt

    return meta


def extract_professors(card):
    profs = []
    for a in card.select("ul li a"):
        if "wieiswie" in a.get("href", ""):
            profs.append(clean_text(a))
    return profs


def extract_tabs(card):
    """Extract Content / Course materials tabs"""
    tabs = {}

    tab_panes = card.select(".tab-pane")
    for pane in tab_panes:
        subject = pane.select(".card-gray")[0].text.strip()

        text = clean_text(pane)

        if not text:
            continue
        if subject == "Content": 
            tabs["content"] = text
        elif "materials" in subject:
            tabs["course_materials"] = text

    return tabs


def extract_activities(course_url):
    soup = get_soup(course_url)

    title = clean_text(soup.find("h1"))

    accordion = soup.find("div", id="accordiononderwijsleeractiviteiten")
    if not accordion:
        return {
            "url": course_url,
            "title": title,
            "activities": []
        }

    activities = []

    cards = accordion.select(".card")

    for card in cards:
        btn = card.select_one("button")

        if not btn:
            continue

        header_text = clean_text(btn)

        # B-KUL code
        code_tag = card.select_one("button span")
        code = clean_text(code_tag)

        meta = extract_metadata(card)
        profs = extract_professors(card)
        tabs = extract_tabs(card)

        activities.append({
            "title": header_text,
            "code": code,
            "metadata": meta,
            "professors": profs,
            "content": tabs.get("content"),
            "course_materials": tabs.get("course_materials")
        })

    return {
        "url": course_url,
        "title": title,
        "activities": activities
    }


# ---------------------------
# FULL CRAWLER
# ---------------------------

def crawl(program_url, max_courses=50, sleep=0.4):
    course_links = extract_course_links(program_url)
    print(f"Found {len(course_links)} courses")

    results = []

    for i, url in enumerate(course_links[:max_courses]):
        try:
            print(f"[{i+1}] {url}")
            data = extract_activities(url)
            results.append(data)

            time.sleep(sleep)

        except Exception as e:
            print("Error:", url, e)

    return results


if __name__ == "__main__":
    START_URL = "https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_51016880?faseIds=1&ids=5030828352697097%2C5030828350291843%2C503082835029184350310023%2C503082835029184350310016%2C503082835029184350310015%2C503082835029184350310013%2C503082835029184350310002%2C50308283502918435031000250310011%2C50308283502918435031000250310005"

    data = crawl(START_URL, max_courses=100)

    with open("kuleuven_programme.json", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print("Saved.")
