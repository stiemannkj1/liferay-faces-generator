# The `attribute` Element

The `attribute` element is designed to contain all the information necessary to generate a JSF attribute.

## Examples

```
<attribute>
	<attribute-extension>
		<alloy-ui>true</alloy-ui>
		<default-value><![CDATA[false]]></default-value>
	</attribute-extension>
	<description><![CDATA[When true, the user must interact with the child dialog window before continuing to interact with the parent.]]></description>
	<name>modal</name>
	<type><![CDATA[boolean]]></type>
</attribute>
```

```
<attribute>
	<attribute-extension>
		<inherited>true</inherited>
	</attribute-extension>
	<description><![CDATA[Specifies whether the HTML element rendered by this component will be a <code>div</code> (default) or a <code>span</code>. If the value of this attribute is <code>block</code>, the rendered element will be a <code>div</code>.]]></description>
	<name>layout</name>
	<type><![CDATA[java.lang.String]]></type>
</attribute>
```

```
<attribute>
	<description><![CDATA[The fully qualified name of the class, enum, or interface which the constants are being imported from.]]></description>
	<name>classType</name>
	<required>true</required>
	<type><![CDATA[java.lang.Object]]></type>
</attribute>
```

## `attribute` Child Elements

| `attribute` Child Element Name | Description | Required | Default Value |
|--------------------------------|-------------|----------|---------------|
| `attribute-extension` | The `<attribute-extension>` element specifies information needed to generate the attribute. See [the *`attribute-extension`s* section](https://github.com/stiemannkj1/liferay-faces-generator/wiki/The-Attriute-Element#attribute-extensions) for more details. | No | None |
| `description` | The `<description>` element specifies a description of the attribute. | No | None |
| `name` | The `<name>` element specifies the name of the attribute. | Yes | None |
| `type` | The `<type>` element specifies the fully qualified type of the attribute | No | `java.lang.Object` |

### `attribute-extension`s

| `attribute-extension` Child Element Name | Description | Required | Default Value |
|------------------------------------------|-------------|----------|---------------|
| `default-value` | The `<default-value>` element specifies a default value for the attribute. "The default value is &lt;code&gt;${default-value}&lt;/code&gt;." will also appear in the attribute description automatically unless the description contains the word `default`. | No | None |
| `inherited` | The `<inherited>` element specifies whether an attribute was inherited. If an attribute is inherited, it will not generate getters/setters (except in special cases such as `styleClass` or `label`). | No | `false` |
| `override` | The `<override>` element specifies whether an attribute's getters/setters will be annotated with `@Override`. | No | `false` |
| `since` | The `<since>` element specifies whether an attribute's description will contain "Since: ${since}" in order to inform developers which version this attribute was included in. | No | None |

### `attribute-extension`s for [Liferay Faces Alloy Components](https://github.com/liferay/liferay-faces-alloy/tree/master/alloy/src/main/java/com/liferay/faces/alloy/component)

| `attribute- extension` Child Element Name | Description | Required | Default Value |
|-------------------------------------------|-------------|----------|---------------|
| `alloy-ui` | The `alloy-ui` element specifies whether an attribute corresponds directly with an AlloyUI JavaScript attribute. If `<alloy-ui>` is set to `true`, then code for rendering the JavaScript attribute based on its server-side value will be generated. | No | If any other `alloy-ui` elements are specified on this attribute, this defaults to `true`, otherwise it defaults to `false` |
| `alloy-ui-name` | The `<alloy-ui-name>` element specifies the AlloyUI JavaScript name of the attribute. | No | Defaults to the `name` of the attribute. |
| `alloy-ui-type` | The `<alloy-ui-type>` element specifies the AlloyUI JavaScript type of the attribute. Valid values include `Boolean`, `ClientId`, `Integer`, and `String` | No | If `alloy-ui-type` is not specified, the generator will attempt to determine the correct `alloy-ui-type` from the attribute's `type` element which may or may not generate code which will not compile because it is not one of the valid values listed.
