.pragma library

// method: "GET" | "POST" | "PATCH" | "DELETE"
// body: objet JS optionnel (sera sérialisé en JSON)
// callback(ok: bool, data: object|null)
function request(method, url, token, body, callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var ok = xhr.status >= 200 && xhr.status < 300
            var data = null
            try {
                data = xhr.responseText ? JSON.parse(xhr.responseText) : null
            } catch (e) {
                data = null
            }
            if (callback) callback(ok, data)
        }
    }
    xhr.open(method, url)
    xhr.setRequestHeader("Authorization", "Bearer " + token)
    if (body !== undefined && body !== null) {
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.send(JSON.stringify(body))
    } else {
        xhr.send()
    }
}
