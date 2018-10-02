# The `facelet-taglib` Element

The `facelet-taglib` element is the root element of the [`tags.xml`](./The-tags.xml-File.md) file. It contains all the information necessary to generate a JSF tag library.

## Examples

```
</facelet-taglib>
	<description><![CDATA[The Liferay Faces Example Tag Library.]]></description>
	<namespace>http://liferay.com/faces/example</namespace>
	<taglib-extension>
		<component-output-directory>${project.build.sourceDirectory}/com/liferay/faces</component-output-directory>
		<component-internal-output-directory>${project.build.sourceDirectory}/com/liferay/faces</component-internal-output-directory>
		<taglib-xml-output-directory>${project.build.sourceDirectory}/../resources/META-INF</taglib-xml-output-directory>
		<authors>
			Bruno Basto,
			Kyle Stiemann
		</authors>
		<copyright-year>2015</copyright-year>
		<default-since>2.0.0</default-since>
		<faces-spec-version>2.0</faces-spec-version>
	</taglib-extension>
	<function>
		<description><![CDATA[Returns a string.]]></description>
		<function-name>aFunction</function-name>
		<function-class><![CDATA[com.liferay.faces.FunctionClass]]></function-class>
		<function-signature><![CDATA[java.lang.String aFunction(java.lang.String)]]></function-signature>
	</function>
	<tag>
		<!-- tag children here -->
	</tag>
</facelet-taglib>
```

## `facelet-taglib` Child Elements

| `facelet-taglib` Child Element Name | Description | Required | Default Value |
|-------------------------------------|-------------|----------|---------------|
| `description` | The `<description>` element specifies a description of the tag library. | No | None |
| `function` | The `<funtion>` element specifies one of the functions of the tag library. A tag library may have many functions. See the [examples](./The-Facelet-Taglib-Element.md#examples) for an example of how to specify a function. | No | None |
| `namespace` | The `<namespace>` element specifies a namespace URI of the tag library. | Yes | None |
| `taglib-extension` | The `<taglib-extension>` element specifies information needed to generate the JSF component suite. See [the *`taglib-extension`s* section](./The-Facelet-Taglib-Element.md#taglib-extensions) for more details. | Yes | None |
| `tag` | The `<tag>` element specifies one of the tags of the tag library. A tag library may have many `tag`s. See [*The `tag` Element* page](./The-Tag-Element.md) for more details. | No | None |

### `taglib-extension`s

| `taglib-extension` Name | Description | Required | Default Value |
|--------------------------|-------------|----------|---------------|
| `authors` | The `<authors>` element specifies a comma separated list of the author names that will be generated in each component's JavaDoc header. | No | None |
| `component-internal-output-directory` | The `<component-internal-output-directory>` element specifies the full path to the folder where `ComponentRenderer.java` and `ComponentRendererBase.java` files will be generated. | No | Defaults to the value of `component-output-directory`. |
| `component-output-directory` | The `<component-output-directory>` element specifies the full path to the folder where `Component.java` and `ComponentBase.java` files will be generated. | Yes | None |
| `copyright-year` | The `<copyright-year>` element specifies the year which will be output in each Java file's copyright header | No | Defaults to the current year. |
| `default-since` | The `<default-since>` element specifies the default value which will be output for each component's [`<vdldoc:since>`](https://github.com/omnifaces/vdldoc/wiki/vdldoc:since) element. This value can be overridden in the `since` element of a tag's `tag-extension` | No | `1.0.0` |
| `faces-spec-version` | The `<faces-spec-version>` element specifies the JSF specification version. It is used to generate the `taglib.xml`'s `<faclet-taglib>` element with the correct namespaces and versions specified. | No | `2.0` |
| `taglib-xml-output-directory` | The `<taglib-xml-output-directory>` element specifies the full file path to the folder where the `taglib.xml` file will be generated. | Yes | None |
