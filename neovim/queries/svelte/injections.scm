(style_element
  (start_tag
    (tag_name) @tag_name
    (attribute
      (attribute_name) @attr_name
      (quoted_attribute_value
        (attribute_value) @attr_value)))
  (raw_text) @raw_text
  (#match? @tag_name "style")
  (#match? @attr_name "lang")
  (#match? @attr_value "\"sass\"")
  (#set! @raw_text "language-injection.sass"))
