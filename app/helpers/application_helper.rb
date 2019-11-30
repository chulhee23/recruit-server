module ApplicationHelper
    def default_yield(sym)
        if content_for?(sym)
            yield(sym)
        else
            render "shared/#{sym.to_s}"
        end
    end
    
    def date_time(element)
      content_tag :span, (element ? element.strftime('%Y/%m/%d %H:%M') : "-")
    end
    
end
