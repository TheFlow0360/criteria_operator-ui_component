// ---------------------------------
// ----- Criteria Editor Plugin ----
// ---------------------------------
// Using John Dugan's boilerplate: https://john-dugan.com/jquery-plugin-boilerplate-explained/
// ---------------------------------

/*
 The semi-colon before the function invocation is a safety net against
 concatenated scripts and/or other plugins which may not be closed properly.

 "undefined" is used because the undefined global variable in ECMAScript 3
 is mutable (ie. it can be changed by someone else). Because we don't pass a
 value to undefined when the anonymyous function is invoked, we ensure that
 undefined is truly undefined. Note, in ECMAScript 5 undefined can no
 longer be modified.

 "window" and "document" are passed as local variables rather than global.
 This (slightly) quickens the resolution process.
 */
;(function ( $, window, document, undefined ) {

    /*
     Store the name of the plugin in the "pluginName" variable. This
     variable is used in the "Plugin" constructor below, as well as the
     plugin wrapper to construct the key for the "$.data" method.

     More: http://api.jquery.com/jquery.data/
     */
    var pluginName = 'criteriaEditor';

    /*
     The "Plugin" constructor, builds a new instance of the plugin for the
     DOM node(s) that the plugin is called on. For example,
     "$('h1').pluginName();" creates a new instance of pluginName for
     all h1's.
     */
    // Create the plugin constructor
    function Plugin ( element, options ) {
        /*
         Provide local access to the DOM node(s) that called the plugin,
         as well local access to the plugin name and default options.
         */
        this.element = element;
        this._name = pluginName;
        this._defaults = $.fn.criteriaEditor.defaults;
        /*
         The "$.extend" method merges the contents of two or more objects,
         and stores the result in the first object. The first object is
         empty so that we don't alter the default options for future
         instances of the plugin.

         More: http://api.jquery.com/jquery.extend/
         */
        this.options = $.extend( {}, this._defaults, options );

        /*
         The "init" method is the starting point for all plugin logic.
         Calling the init method here in the "Plugin" constructor function
         allows us to store all methods (including the init method) in the
         plugin's prototype. Storing methods required by the plugin in its
         prototype lowers the memory footprint, as each instance of the
         plugin does not need to duplicate all of the same methods. Rather,
         each instance can inherit the methods from the constructor
         function's prototype.
         */
        this.init();
    }

    // Avoid Plugin.prototype conflicts
    $.extend(Plugin.prototype, {

        // Initialization logic
        init: function () {
            /*
             Create additional methods below and call them via
             "this.myFunction(arg1, arg2)", ie: "this.buildCache();".

             Note, you can access the DOM node(s), plugin name, default
             plugin options and custom plugin options for a each instance
             of the plugin by using the variables "this.element",
             "this._name", "this._defaults" and "this.options" created in
             the "Plugin" constructor function (as shown in the buildCache
             method below).
             */
            this.buildCache();
            this.bindEvents();
        },

        // Remove plugin instance completely
        destroy: function() {
            /*
             The destroy method unbinds all events for the specific instance
             of the plugin, then removes all plugin data that was stored in
             the plugin instance using jQuery's .removeData method.

             Since we store data for each instance of the plugin in its
             instantiating element using the $.data method (as explained
             in the plugin wrapper below), we can call methods directly on
             the instance outside of the plugin initialization, ie:
             $('selector').data('plugin_myPluginName').someOtherFunction();

             Consequently, the destroy method can be called using:
             $('selector').data('plugin_myPluginName').destroy();
             */
            this.unbindEvents();
            this.$element.removeData();
        },

        // Cache DOM nodes for performance
        buildCache: function () {
            /*
             Create variable(s) that can be accessed by other plugin
             functions. For example, "this.$element = $(this.element);"
             will cache a jQuery reference to the element that initialized
             the plugin. Cached variables can then be used in other methods.
             */
            this.$element = $(this.element);
            this.$valueInput = this.$element.find(this.options.valueInput)
        },

        // Bind events that trigger methods
        bindEvents: function() {
            var plugin = this;

            /*
             Bind event(s) to handlers that trigger other functions, ie:
             "plugin.$element.on('click', function() {});". Note the use of
             the cached variable we created in the buildCache method.

             All events are namespaced, ie:
             ".on('click'+'.'+this._name', function() {});".
             This allows us to unbind plugin-specific events using the
             unbindEvents method below.
             */
            //plugin.$element.on('click'+'.'+plugin._name, function() {
                /*
                 Use the "call" method so that inside of the method being
                 called, ie: "someOtherFunction", the "this" keyword refers
                 to the plugin instance, not the event handler.

                 More: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call
                 */
            //    plugin.someOtherFunction.call(plugin);
            //});
            plugin.$element.find(plugin.options.newExpression).on('click'+'.'+plugin._name, function(event) {
                plugin.createElement.call(plugin, 'expression', plugin.options, event.target);
            });
            plugin.$element.find(plugin.options.newGroup).on('click'+'.'+plugin._name, function(event) {
                plugin.createElement.call(plugin, 'group', plugin.options, event.target);
            });
            plugin.$element.find(plugin.options.deleteExpression).on('click'+'.'+plugin._name, function(event) {
                plugin.deleteElement.call(plugin, plugin.options, event.target);
            });
            plugin.$element.find(plugin.options.deleteGroup).on('click'+'.'+plugin._name, function(event) {
                plugin.deleteElement.call(plugin, plugin.options, event.target);
            });
            plugin.$element.find(plugin.options.operandInput).on('change'+'.'+plugin._name, function(event) {
                plugin.operandChanged.call(plugin, plugin.options, event.target);
            });
            plugin.$element.find(plugin.options.operatorTypeInput).on('change'+'.'+plugin._name, function(event) {
                plugin.operatorTypeChanged.call(plugin, plugin.options, event.target);
            });
        },

        // Unbind events that trigger methods
        unbindEvents: function() {
            /*
             Unbind all events in our plugin's namespace that are attached
             to child elements.
             */
            this.$element.find("*").off('.'+this._name);
        },

        createElement: function(type, options, element) {
            var plugin = this;
            var requestData = {};
            requestData["root_operator"] = plugin.$valueInput.val();
            requestData["locator"] = plugin.buildLocatorChain(element, options);
            requestData["child_count"] = $(element).parent().data("childcount");
            $.ajax({
                url: "/criteria_operator-ui_component/create_" + type,
                data: requestData,
                method: "POST"
            }).done(function(data) {
                var wrapper = $(element).parent().children(options.rowWrapper);
                wrapper.children(options.placeholder).remove();
                wrapper.append(data['html']);
                $(element).parent().data("childcount", $(element).parent().data("childcount") + 1);
                plugin.$valueInput.val(data['operator']);
                plugin.rebind();
            });
        },

        deleteElement: function(options, element) {
            var plugin = this;
            var requestData = {};
            requestData["root_operator"] = plugin.$valueInput.val();
            requestData["locator"] = plugin.buildLocatorChain(element, options);
            $.ajax({
                url: "/criteria_operator-ui_component/delete_element",
                data: requestData,
                method: "POST"
            }).done(function(data) {
                $(element).parent().nextAll().each(function() {
                    $( this ).attr('data-locator', $( this ).attr('data-locator') - 1);
                });
                var parentGroup = $(element).parent().parent().parent();
                parentGroup.data("childcount", parentGroup.data("childcount") - 1);
                $(element).parent().remove()
                plugin.$valueInput.val(data['operator']);
            });
        },

        operandChanged: function(options, element) {
            var plugin = this;
            var requestData = {};
            requestData["root_operator"] = plugin.$valueInput.val();
            requestData["locator"] = plugin.buildLocatorChain(element, options);
            if ($(element).hasClass(options.binaryLeftOperandClass)) {
                requestData["operand_type"] = "left";
            } else if ($(element).hasClass(options.binaryRightOperandClass)) {
                requestData["operand_type"] = "right";
            } else { return }
            requestData["operand_value"] = $(element).val();
            $.ajax({
                url: "/criteria_operator-ui_component/operand_change",
                data: requestData,
                method: "POST"
            }).done(function(data) {
                plugin.$valueInput.val(data['operator']);
            });
        },

        operatorTypeChanged: function(options, element) {
            var plugin = this;
            var requestData = {};
            requestData["root_operator"] = plugin.$valueInput.val();
            requestData["locator"] = plugin.buildLocatorChain(element, options);
            requestData["operator_type_value"] = $(element).val();
            var type;
            if ($(element).hasClass(options.expressionOperatorTypeClass)) {
                type = "expression_type_change"
            } else if ($(element).hasClass(options.groupOperatorTypeClass)) {
                type = "group_type_change"
            } else { return }
            $.ajax({
                url: "/criteria_operator-ui_component/" + type,
                data: requestData,
                method: "POST"
            }).done(function(data) {
                plugin.$valueInput.val(data['operator']);
            });
        },

        rebind: function() {
            // TODO: reduce workload by just binding new instead of rebinding all
            var plugin = this;
            plugin.unbindEvents();
            plugin.bindEvents();
        },

        buildLocatorChain: function(element, options) {
            if ($(element).hasClass(options.rootElementClass)) {
                return ""
            } else {
                var chain = this.buildLocatorChain($(element).parent(), options);
                var locator = $(element).attr("data-locator");
                if (typeof locator !== typeof undefined && locator !== false) {
                    chain = (chain === "" ? "" : chain + "," ) + locator;
                }
                return chain;
            }
        }
    });

    /*
     Create a lightweight plugin wrapper around the "Plugin" constructor,
     preventing against multiple instantiations.

     More: http://learn.jquery.com/plugins/basic-plugin-creation/
     */
    $.fn.criteriaEditor = function ( options ) {
        this.each(function() {
            if ( !$.data( this, "plugin_" + pluginName ) ) {
                /*
                 Use "$.data" to save each instance of the plugin in case
                 the user wants to modify it. Using "$.data" in this way
                 ensures the data is removed when the DOM element(s) are
                 removed via jQuery methods, as well as when the user leaves
                 the page. It's a smart way to prevent memory leaks.

                 More: http://api.jquery.com/jquery.data/
                 */
                $.data( this, "plugin_" + pluginName, new Plugin( this, options ) );
            }
        });
        /*
         "return this;" returns the original jQuery object. This allows
         additional jQuery methods to be chained.
         */
        return this;
    };

    /*
     Attach the default plugin options directly to the plugin object. This
     allows users to override default plugin options globally, instead of
     passing the same option(s) every time the plugin is initialized.

     For example, the user could set the "property" value once for all
     instances of the plugin with
     "$.fn.pluginName.defaults.property = 'myValue';". Then, every time
     plugin is initialized, "property" will be set to "myValue".

     More: http://learn.jquery.com/plugins/advanced-plugin-concepts/
     */
    $.fn.criteriaEditor.defaults = {
        property: 'value',
        onComplete: null,
        rootElementClass: 'criteria_editor',
        newExpression: '.criteria_editor_new_expression',
        newGroup: '.criteria_editor_new_group',
        placeholder: '.criteria_editor_empty_placeholder',
        rowWrapper: '.criteria_editor_row_wrapper',
        deleteExpression: '.criteria_expression_delete',
        deleteGroup: '.criteria_group_delete',
        valueInput: '.criteria_editor_root_operator',
        operandInput: '.criteria_operand_input',
        operatorTypeInput: '.criteria_operator_type_input',
        binaryLeftOperandClass: 'binary_operator_left_operand',
        binaryRightOperandClass: 'binary_operator_right_operand',
        expressionOperatorTypeClass: 'expression_operator_type',
        groupOperatorTypeClass: 'group_operator_type'
    };

})( jQuery, window, document );

$(document).ready(function() {
    $('.criteria_editor').criteriaEditor({
        rootElementClass: 'criteria_editor'
    });
});
