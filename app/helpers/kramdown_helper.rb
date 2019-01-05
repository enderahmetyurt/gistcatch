# frozen_string_literal: true

module KramdownHelper
  require 'kramdown'
  require 'rouge'

  def format_collection(content_collection)
    filecontent_html = ''
    content_collection.each do |filename, details|
      filecontent_html << "<h5>#{filename}</h5><hr><div>#{file_preview(details)}</div>"
    end
    filecontent_html
  end

  def file_preview(details)
    if /image/.match?(details[:type])
      image_tag(details[:raw_url], alt: details[:filename])
    else
      kramdown_rouge_prepare(details[:content], details[:language])
    end
  end

  def kramdown_rouge_prepare(text, lang)
    lang ||= 'txt' # Lang shoud be nil. Set default as txt
    formatter = Rouge::Formatters::HTMLLegacy.new(line_numbers: false, css_class: 'highlight')
    if lang == 'Markdown'
      sanitize Kramdown::Document.new(text, smart_quotes: 'lsquo,rsquo,ldquo,rdquo',
                                            entity_output: 'as_char',
                                            toc_levels: '1..6',
                                            auto_ids: false,
                                            footnote_nr: 1,
                                            show_warnings: true,
                                            syntax_highlighter: 'rouge',
                                            syntax_highlighter_opts: {
                                              default_lang: lang || 'plaintext',
                                              bold_every: 8,
                                              css: :class,
                                              css_class: 'highlight',
                                              formatter: formatter
                                            }).to_html
    else
      lexer = Rouge::Lexer.find(lang.downcase) || Rouge::Lexer.find('plaintext')
      formatter.format(lexer.lex(text))
    end
  end
end
