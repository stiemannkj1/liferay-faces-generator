# The `tag` Element

The `tag` element is designed to contain all the information that is useful for generating a JSF Component.

## `tag` Child Elements

| `tag` Child Element Name | Description | Required | Default Value |
|--------------------------|-------------|----------|---------------|
| `attribute` | The `<attribute>` element specifies one of the attributes of the tag. A tag may have many `attribute`s. See [*The `attribute` Element* page]() for more details. | No | None |
| `description` | The `<description>` element specifies a description of the tag. | No | None |
| `handler-class` | The `<handler-class>` element specifies the fully qualified class name of the tag's tag handler. | No | None |
| `tag-extension` | The `<tag-extension>` element specifies information needed to generate the component. See [the *`tag-extension`s* section below](https://github.com/stiemannkj1/liferay-faces-generator/wiki/The-Tag-Element#tag-extensions) for more details. | Yes | None |
| `tag-name` | The `<tag-name>` element specifies the tag's name. The name should be specified as CamelCase and begin with a lower case character. | Yes | None |

### `tag-extension`s

| `tag- extension` Child Element Name | Description | Required | Default Value |
|-------------------------------------|-------------|----------|---------------|
| `delegate- component- family` | The `<delegate-component-family>` element specifies the component family of the component's delegate renderer. The delegate component family is a key used with the delegate renderer type to determine which renderer the component will delegate to. | No | If a `delegate- renderer-type` has been specified then `delegate- component-family` defaults to the component's `COMPONENT_FAMILY` constant value. |
| `delegate- renderer- type` | The `<delegate-renderer-type>` element specifies the renderer type of the component's delegate renderer. The delegate renderer type is a key used with the delegate component family to determine which renderer the component will delegate to. | No | None |
| `extends- tags` | The `<extends-tags>` element specifies a space separated list of all the tags which the current tag extends from. Extending a tag causes a tag to gain all the attributes of the tag which was extended. | No | None |
| `extra- style- classes` | The `<extra-style-classes>` element specifies a space separated list of all the CSS classes which should be rendered on this component by default. | No | None |
| `generate- component` | The `<generate-component>` element specifies whether the component Java files for this component will be generated. | No | `false` |
| `generate- java` | The `<generate-java>` element specifies whether the Java files for this component will be generated. Setting `generate-java` to `false` is useful in combination with setting `generate-taglib-xml` to `false` in order to create components which are simply groups of attributes for other components to extend. | No | `false` |
| `generate- renderer` | The `<generate-renderer>` element specifies whether the component Java files for this component will be generated. | No | `false` |
| `generate- taglib- xml` | The `<generate-taglib-xml>` element specifies whether the a tag entry for this component will be generated in the `taglib.xml` file. Setting `generate-taglib-xml` to false is useful for generating components that other components can extend. | No | `false` |
| `handler- class- only` | The `<handler-class-only>` element specifies whether the component is simply a JSF [`TagHandler`](http://docs.oracle.com/javaee/6/api/javax/faces/view/facelets/TagHandler.html) component. If `handler-class-only` is `true`, then the generator will not generate `component-type` or `renderer-type` elements for the tag in the `taglib.xml` file. | No | `false` |
| `parent- class` | The `<parent-class>` element specifies the fully qualified parent class of the generated component's base class. | No | `javax.faces. component. UIComponentBase` |
| `renderer- parent- class` | The `<renderer-parent-class>` element specifies the fully qualified parent class of the generated component's renderer base class. | No | `javax.faces. render.Renderer` |
| `since` | The `<since>` element specifies the first version in which the tag was available for the purpose of generating [`<vdldoc:since>`](https://github.com/omnifaces/vdldoc/wiki/vdldoc:since) documentation. | No | If the `taglib-extension` `default-since` element has been specified, then `since` will default to the value of `default-since`. If not, it defaults to `1.0.0`. |

### `tag-extension`s for [Liferay Faces Alloy Components](https://github.com/liferay/liferay-faces-alloy/tree/master/alloy/src/main/java/com/liferay/faces/alloy/component)

| `tag- extension` Child Element Name | Description | Required | Default Value |
|-------------------------------------|-------------|----------|---------------|
| `alloy- ui- module` | The `<alloy-ui-module>` element specifies the [AlloyUI JavaScript module](http://alloyui.com/versions/2.0.x/api/) of the component. If this element exists, the component renderer base file will be generated via the [`AlloyComponentRendererBase.java.ftl` template](https://github.com/stiemannkj1/liferay-faces-generator/blob/master/src/main/resources/templates/AlloyComponentRendererBase.java.ftl) rather than the [`ComponentRendererBase.java.ftl` template](https://github.com/stiemannkj1/liferay-faces-generator/blob/master/src/main/resources/templates/ComponentRendererBase.java.ftl). | No | None |
| `alloy-ui- name` | The `<alloy-ui-name>` element specifies the name of the [AlloyUI JavaScript component](http://alloyui.com/versions/2.0.x/api/) which the JSF component will render. | No | If an `alloy-ui- module` has been specified, this defaults to the name of the tag, otherwise there is no default. |

## Examples

```
<tag>
	<tag-name>autoComplete</tag-name>
	<handler-class>com.liferay.faces.alloy.component.autocomplete.internal.AutoCompleteHandler</handler-class>
	<attribute>
		<!-- attribute children here --> 
	</attribute>
	<tag-extension>
		<alloy-ui-module>autocomplete</alloy-ui-module>
		<alloy-ui-name>Autocomplete</alloy-ui-name>
		<delegate-component-family><![CDATA["javax.faces.TextRenderer"]]></delegate-component-family>
		<delegate-renderer-type><![CDATA["javax.faces.Text"]]></delegate-renderer-type>
		<extends-tags>clientComponent facesMessageLabelTaglibXMLOnly inputText</extends-tags>
		<extra-style-classes>autocomplete</extra-style-classes>
		<generate-component>true</generate-component>
		<generate-renderer>true</generate-renderer>
		<handler-class-only>false</handler-class-only>
		<parent-class><![CDATA[com.liferay.faces.alloy.component.inputtext.InputTextBase]]></parent-class>
		<renderer-parent-class><![CDATA[com.liferay.faces.alloy.render.internal.DelegatingAlloyRendererBase]]></renderer-parent-class>
		<since>2.0</since>
	</tag-extension>
</tag>
```

```
<tag>
	<tag-name>styleable</tag-name>
	<attribute>
		<!-- attribute children here --> 
	</attribute>
	</tag-extension>
		<generate-java>false</generate-java>
		<generate-taglib-xml>false</generate-taglib-xml>
	</tag-extension>
</tag>
```