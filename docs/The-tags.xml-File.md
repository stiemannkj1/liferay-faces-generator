# The `tags.xml` File

The `tags.xml` file is designed to be as similar to a JSF `taglib.xml` file as possible, while adding some extra features to help component developers. From the `tags.xml` file, the generator can generate:

- The `Component.java` file
- The `ComponentBase.java` file
- The `ComponentRenderer.java` file
- The `ComponentRendererBase.java` file
- And the component's `taglib.xml` documentation

Here is an example `new-tags.xml` file:

```
<?xml version='1.0' encoding='UTF-8'?>
<facelet-taglib>
	<description><![CDATA[The New facelet component tags with the <code>new:</code> tag name prefix.]]></description>
	<namespace>http://liferay.com/faces/new</namespace>
	<taglib-extension>
		<component-output-directory>${project.build.sourceDirectory}/com/liferay/faces</component-output-directory>
		<taglib-xml-output-directory>${project.build.sourceDirectory}/../resources/META-INF</taglib-xml-output-directory>
		<authors>
			A Author,
			B Author
		</authors>
		<default-since>1.0.0</default-since>
	</taglib-extension>
	<tag>
		<description><![CDATA[A new Tag.]]></description>
		<tag-name>newTag</tag-name>
		<attribute>
			<attribute-extension>
				<default-value>""</default-value>
			</attribute-extension>
			<description><![CDATA[A new attribute.]]></description>
			<name>newAttr</name>
			<type><![CDATA[java.lang.String]]></type>
		</attribute>
		<tag-extension>
			<extends-tags>styleable</extends-tags>
		</tag-extension>
	</tag>
<facelet-taglib>
```

The `tags.xml` file name is required to be of the form `${shortNamespace}-tags.xml` (e.g. `alloy-tags.xml`).

The generator accepts certain elements as [`taglib-extesion`s](./The-Facelet-Taglib-Element.md#taglib-extensions), [`tag-extesions`s](./The-Tag-Element#tag-extensions.md), and [`attribute-extesions`s](./The-Attribute-Element.md#attribute-extensions) in order to obtain all the necessary information for generation and to reduce duplication. See each extension page for more details.

## Other Examples

The Liferay Faces Projects contain several examples of `tags.xml` pages:

- [`alloy-tags.xml`](https://github.com/liferay/liferay-faces-alloy/blob/master/alloy/alloy-tags.xml)
- [`bridge-tags.xml`](https://github.com/liferay/liferay-faces-bridge-impl/blob/master/bridge-impl/bridge-tags.xml)
- [`portal-tags.xml`](https://github.com/liferay/liferay-faces-portal/blob/master/portal/portal-tags.xml)
- [`portlet-tags.xml`](https://github.com/liferay/liferay-faces-bridge-impl/blob/master/bridge-impl/portlet-tags.xml)