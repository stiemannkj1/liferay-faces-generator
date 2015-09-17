# The Liferay Faces Generator Freemarker Templates

The Generator uses [Freemarker](http://freemarker.org/) to generate all its
files. The generator is designed so that it should be unnecessary to make many
changes to the Java code. So if you need to make changes, the Freemarker
templates are the place to do it.

## Adding an Element

If the generator needs to become aware of a new element in order to improve the
generated code, that feature can easily be added in the Freemarker templates
without modifying any Java code. As an example, let's say that the generator
needs to be made aware that a tag utilizes a class in the `foo.js` JavaScript
library. The best way to add this feature would be to add
`<foo-class>ExampleClass</foo-class>` to the tag's `<tag-extension>` element in
**`example-tags.xml`**:

```
<tag>
	<tag-name>exampleTag</tag-name>
	<attribute>
		<name>exampleAttribute</name>
		<type>java.lang.String</type>
	</attribute>
	<tag-extension>
		<foo-class>ExampleClass</foo-class>
	</tag-extension>
</tag>
```

Then in the appropriate template(s), add code to access the value of the
element using xpath.

To check if the element exists, use the following code:*

	tag["tag-extension/foo-class"][0]??

To get the element's value, use the following code:

	tag["tag-extension/foo-class"]

<sup>* **Note:** `tag["tag-extension/foo-class"]??` cannot be used to check
element existence for reasons outlined
[here](http://freemarker.org/docs/xgui_imperative_learn.html#autoid_132).</sup>

## The Templates

| Template Name | Description |
|---------------|-------------|
| `AlloyComponentRendererBase.java.ftl` | `AlloyComponentRendererBase.java.ftl` is designed to generate the renderer base class for components which utilize AlloyUI JavaScript. In `ComponentRendererBase.java.ftl`, before any generation is done, the template checks if the component is an AlloyUI component and activates this template if it is. |
| `Component.java.ftl` | `Component.java.ftl` is designed to generate a stub of a component class. The component class is designed to be edited manually, so this class is only generated if the file does not already exists. |
| `ComponentBase.java.ftl` | `ComponentBase.java.ftl` is designed to generate a base class for the JSF component. This template will generate all getters/setters for attributes as well as helpful constants for the component's `COMPONENT_TYPE` and `RENDERER_TYPE`. This class is not designed to be edited manually, and it will always be generated if there are changes. |
| `ComponentRenderer.java.ftl` | `ComponentRenderer.java.ftl` is designed to generate a stub of a component renderer class. The component renderer class is designed to be edited manually, so this class is only generated if the file does not already exists. |
| `ComponentRendererBase.java.ftl` | `ComponentRendererBase.java.ftl` is designed to generate a base renderer class for the JSF component. This template will generate a renderer base class for a component. If the component uses AlloyUI, this template will generate the renderer base class by by including the `AlloyComponentRendererBase.java.ftl` template otherwise this template will generate the renderer base class itself. This template will generate methods for delegate rendering as well as helpful constants for rendering. This class is not designed to be edited manually, and it will always be generated if there are changes. |
| `ComponentRendererTemplateFunctions.ftl` | `ComponentRendererTemplateFunctions.ftl` contains functions and macros useful for generating renderers. It must be included in each file where a function is used via `<#include "./ComponentRendererTemplateFunctions.ftl" />`. |
| `ComponentTemplateFunctions.ftl` | `ComponentTemplateFunctions.ftl` contains functions and macros useful for generating components and renderers. It must be included in each file where a function is used via `<#include "./ComponentTemplateFunctions.ftl" />`. |
| `TemplateFunctions.ftl` | `TemplateFunctions.ftl` contains functions and macros useful for all templates. It must be included in each file where a function is used via `<#include "./TemplateFunctions.ftl" />`. |
| `taglib.xml.ftl` | `taglib.xml.ftl` is designed to generate the Facelet `taglib.xml` file. This file is not designed to be edited manually, and it will always be generated if there are changes. |

### Helpful Links for Freemarker Template Developers

- [*Template Author's Guide*](http://freemarker.org/docs/dgui.html)
- [*XML Processing Guide*](http://freemarker.org/docs/xgui.html)

#### Freemarker Built-ins

- [*Built-ins for nodes (for XML)*](http://freemarker.org/docs/ref_builtins_node.html)
- [*Built-in Reference*](http://freemarker.org/docs/ref_builtins.html)
- [*Built-ins for strings*](http://freemarker.org/docs/ref_builtins_string.html)
- [*String slicing (substrings)*](http://freemarker.org/docs/dgui_template_exp.html#dgui_template_exp_stringop_slice)
- [*Built-ins for sequences*](http://freemarker.org/docs/ref_builtins_sequence.html)

#### Freemarker Directives

- [*Directive Reference*](http://freemarker.org/docs/ref_directives.html)
- [*if, else, elseif*](http://freemarker.org/docs/ref_directive_if.html)
- [*list, else, items, sep, break*](http://freemarker.org/docs/ref_directive_list.html)
- [*assign*](http://freemarker.org/docs/ref_directive_assign.html)
- [*function, return*](http://freemarker.org/docs/ref_directive_function.html)
- [*macro, nested, return*](http://freemarker.org/docs/ref_directive_macro.html)
- [*local*](http://freemarker.org/docs/ref_directive_local.html)
