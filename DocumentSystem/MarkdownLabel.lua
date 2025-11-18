local mod = dmhub.GetModLoading()

function gui.MarkdownLabel(options)
    local m_text = options.text or ""
    local doc = MarkdownDocument.new{
        content = m_text,
        annotations = options.annotations or {},
    }


    options.text = nil
    options.annotations = nil

    options.width = options.width or "100%"
    options.height = options.height or "auto"
    options.vscroll = options.vscroll or false
    options.noninteractive = options.noninteractive

    options.doc = function(element, doc)
        element:FireEventTree("refreshDocument", doc)
    end

    options.GetValue = function(element)
        return m_text
    end

    options.SetValue = function(element, value)
        m_text = value
        doc = MarkdownDocument.new{
            content = m_text,
            annotations = doc.annotations,
        }
        element:FireEventTree("refreshDocument", doc)
    end

    return doc:DisplayPanel(options)
end