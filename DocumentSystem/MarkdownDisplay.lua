local mod = dmhub.GetModLoading()

function gui.DocumentDisplay(args)
    if args.text == nil or args.text == "" then
        return nil
    end

    local markdownArgs = {}

    markdownArgs.id = args.id or dmhub.GenerateGuid()
    args.id = nil

    markdownArgs.description = args.description or "none"
    args.description = nil

    markdownArgs.content = args.text
    args.text = nil

    markdownArgs.annotations = args.annotations or {}
    args.annotations = nil

    local doc = MarkdownDocument.new(markdownArgs)
    return doc:DisplayPanel(args)
end