# `tag-extension`s

| `tag- extension` Name | Description | Required | Default Value |
|-----------------------|-------------|----------|---------------|
| `extends- tags` | The `<extends-tags>` element specifies a space separated list of all the tags which the current tag extends from. Extending a tag causes a tag to gain all the attributes of the tag which was extended. | No | None |
| `extra-s tyle- classes` | The `<extra-style-classes>` element specifies a space separated list of all the CSS classes which should be rendered on this component by default. | No | None |
| `delegate- component- family` | The `<delegate-component-family>` element specifies the component family of the component's delegate renderer. The delegate component family is a key used with the delegate renderer type to determine which renderer the component will delegate to. | No | If a `delegate- renderer- type` has been specified then `delegate- component- family` defaults to the component's `COMPONENT_FAMILY` constant value. |
| `delegate- renderer- type` | The `<delegate-renderer-type>` element specifies the renderer type of the component's delegate renderer. The delegate renderer type is a key used with the delegate component family to determine which renderer the component will delegate to. | No | None |
| `parent- class` | The `<parent-class>` element specifies the parent class of the generated component's base class. | No | `javax. faces. component. UIComponentBase` |
| `renderer- parent- class` | The `<renderer-parent-class>` element specifies the parent class of the generated component's renderer base class. | No | `javax. faces. render. Renderer` |
| `since` | The `<since>` element specifies the first version in which the tag was available for the purpose of generating [`<vdldoc:since>`](https://github.com/omnifaces/vdldoc/wiki/vdldoc:since) documentation. | No | If the `taglib- extension` `default- since` element has been specified, then `since` will default to the value of `default-since`. If not, it defaults to `1.0`. |

## Alloy Specific `tag-extension`s

| `tag- extension` Name | Description | Required | Default Value |
|-----------------------|-------------|----------|---------------|
| `alloy- ui- module` | The `<alloy-ui-module>` element specifies the [AlloyUI JavaScript module](http://alloyui.com/versions/2.0.x/api/) of the component. If this element exists, the component renderer base file will be generated via the [`AlloyComponentRendererBase.java.ftl` template](https://github.com/stiemannkj1/liferay-faces-generator/blob/master/src/main/resources/templates/AlloyComponentRendererBase.java.ftl) rather than the [`ComponentRendererBase.java.ftl` template](https://github.com/stiemannkj1/liferay-faces-generator/blob/master/src/main/resources/templates/ComponentRendererBase.java.ftl). | No | None |
| `alloy- ui- name` | The `<alloy-ui-name>` element specifies the name of the [AlloyUI JavaScript component](http://alloyui.com/versions/2.0.x/api/) which the JSF component will render. | No | If an `<alloy- ui- module>` has been specified, this defaults to the name of the tag, otherwise there is no default. |