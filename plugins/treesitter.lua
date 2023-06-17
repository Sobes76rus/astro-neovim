local highlights = [[
(comment) @comment
(content) @none

; Custom tag name, aka VueComponent
(tag_name) @type
; Regular tag name
(
  (tag_name) @_tag_name
  ; https:;www.script-example.com/html-tag-liste
  (#any-of? @_tag_name
   "head" "title" "base" "link" "meta" "style"
   "body" "article" "section" "nav" "aside" "h1" "h2" "h3" "h4" "h5" "h6" "hgroup" "header" "footer" "address"
   "p" "hr" "pre" "blockquote" "ol" "ul" "menu" "li" "dl" "dt" "dd" "figure" "figcaption" "main" "div"
   "a" "em" "strong" "small" "s" "cite" "q" "dfn" "abbr" "ruby" "rt" "rp" "data" "time" "code" "var" "samp" "kbd" "sub" "sup" "i" "b" "u" "mark" "bdi" "bdo" "span" "br" "wbr"
   "ins" "del"
   "picture" "source" "img" "iframe" "embed" "object" "param" "video" "audio" "track" "map" "area"
   "table" "caption" "colgroup" "col" "tbody" "thead" "tfoot" "tr" "td" "th"
   "form" "label" "input" "button" "select" "datalist" "optgroup" "option" "textarea" "output" "progress" "meter" "fieldset" "legend"
   "details" "summary" "dialog"
   "script" "noscript" "template" "slot" "canvas")
) @tag

; Tag attributes
(id) @variable.builtin
(class) @constant.builtin

(attribute_name) @tag.attribute
(
  (attribute_name) @_attr_name
  (#match? @_attr_name "^((:|v-).*)$")
) @symbol

(quoted_attribute_value) @string
(attribute 
  (javascript) @string
)
(
  (attribute
    (attribute_name) @_attr_name
    (#match? @_attr_name "^((:|v-).*)$")
    (quoted_attribute_value (attribute_value) @none)
  )
) 
(
  (attribute
    (attribute_name) @_attr_name
    (#match? @_attr_name "^((:|v-).*)$")
    (javascript) @none
  )
) 


[
  ":"
  "{{"
  "}}"
  "+"
  "|"
] @punctuation.delimiter

(keyword) @keyword
((keyword) @include (#eq? @include "include"))
((keyword) @repeat (#any-of? @repeat "for" "each" "of" "in" "while"))
((keyword) @conditional (#any-of? @conditional "if" "else" "else if" "unless"))
((keyword) @keyword.function (#any-of? @keyword.function "block" "mixin"))

(filter_name) @method.call

(mixin_use (mixin_name) @method.call)
(mixin_definition (mixin_name) @function)
]]

local injections = [[
(
  (attribute
    (attribute_name) @_attr_name
    (#match? @_attr_name "^((:|v-).*)$")
    (quoted_attribute_value (attribute_value) @javascript)
  )
) 
(
  (attribute
    (attribute_name) @_attr_name
    (#match? @_attr_name "^((:|v-).*)$")
    (javascript) @javascript
  )
) 
]]

local indents = [[
(tag) @indent.begin
]]

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  commit = "840e5d71787b02789f909315f646a6dd66a0de2c",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "html",
      "css",
      "lua",
      "pug",
      "vue",
      "typescript",
      "javascript",
      "rust",
      "go",
    })
    opts.indent = {
      enable = true,
    }

    require("vim.treesitter.query").set("pug", "highlights", highlights)
    require("vim.treesitter.query").set("pug", "injections", injections)
    require("vim.treesitter.query").set("pug", "indents", indents)
  end,
}
