var JqueryUiInteractions = function() {
// Selectable
    var _componentUiSelectable = function() {
        if (!$().selectable) {
            console.warn('Warning - jQuery UI components are not loaded.');
            return;
        }


        // Serialize
        $('#selectable-form-sheet').selectable({
            stop: function() {
                var result = $('#select-result').empty();
                $('.ui-selected', this).each(function() {
                    var index = $('#selectable-serialize li').index(this);
                    result.append(' #' + (index + 1));
                });
            }
        });
    };

    return {
        init: function() {
            // _componentUiDraggable();
            // _componentUiDroppable();
            // _componentUiResizable();
            _componentUiSelectable();
            // _componentUiSortable();
        }
    }
}();
var CardsDraggable = function(){
    let index_info = [];
    var _componentSortable = function() {
        if (!$().sortable) {
            console.warn('Warning - jquery_ui.js components are not loaded.');
            return;
        }

        // Sortable rows
        $('.row-sortable').sortable({
            connectWith: '.row-sortable',
            items: '.card',
            helper: 'original',
            cursor: 'move',
            handle: '[data-action=move]',
            revert: 100,
            containment: '.content-wrapper',
            forceHelperSize: true,
            placeholder: 'sortable-placeholder',
            forcePlaceholderSize: true,
            tolerance: 'pointer',
            start: function(e, ui){
                ui.placeholder.height(ui.item.outerHeight());
            },
            beforeStop: function( event, ui ) {
              index_info = {
                priority: $.map($(".sortable-card"),function(v,i){
                  return [{id:$(v).data('question-id'), priority: i}]
                })
              }

              Rails.ajax({
                url: "/question_sheets/position",
                type: "patch",
                data: $.param(index_info)
              })
              //$(".sortable-card").each(function(index) {
              //  console.log($(this), index, $(".sortable-card").length);
                // question_id =
                // Rails.ajax
              //});
            }
        });
    }
    return {
        init: function() {
            _componentSortable();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    CardsDraggable.init();
    // JqueryUiInteractions.init();
});
