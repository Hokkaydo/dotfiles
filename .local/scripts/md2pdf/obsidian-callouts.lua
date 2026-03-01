function BlockQuote(el)

  if #el.content == 0 then
    return nil
  end

  local first = el.content[1]
  if first.t ~= "Para" then
    return nil
  end

  local inlines = first.content

  -- We reconstruct only until we hit ']' in tokens
  local marker = ""
  local end_index = nil

  for i, inline in ipairs(inlines) do
    marker = marker .. pandoc.utils.stringify(inline)

    if pandoc.utils.stringify(inline):match("%]") then
      end_index = i
      break
    end
  end

  if not end_index then
    return nil
  end

  marker = marker:gsub("^%s+", ""):gsub("%s+$", "")

  local callout_type, title =
    marker:match("^%[!%s*(%w+)%s*(|%s*(.-)%s*)?%]")

  if not callout_type then
    return nil
  end

  -- Remove marker tokens from first paragraph
  local new_inlines = {}
  for i = end_index + 1, #inlines do
    table.insert(new_inlines, inlines[i])
  end

  if #new_inlines > 0 then
    el.content[1] = pandoc.Para(new_inlines)
  else
    table.remove(el.content, 1)
  end

  local type_map = {
    def = "definition",
    thm = "theorem",
    lemma = "lemma",
    prop = "proposition",
    remark = "remark",
    example = "example"
  }

  local env = type_map[callout_type] or callout_type

  local blocks = {}

  if title and title ~= "" then
    table.insert(blocks,
      pandoc.RawBlock("latex",
        "\\begin{" .. env .. "}[" .. title .. "]"
      )
    )
  else
    table.insert(blocks,
      pandoc.RawBlock("latex",
        "\\begin{" .. env .. "}"
      )
    )
  end

  for _, b in ipairs(el.content) do
    table.insert(blocks, b)
  end

  table.insert(blocks,
    pandoc.RawBlock("latex",
      "\\end{" .. env .. "}"
    )
  )

  return blocks
end

