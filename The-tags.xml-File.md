# The `tags.xml` File

The `tags.xml` file is designed to be as similar to a JSF `taglib.xml` file as possible, while adding some extra features to help component developers. From the `tags.xml` file, the generator can generate:

- The `Component.java` file
- The `ComponentBase.java` file
- The `ComponentRenderer.java` file
- The `ComponentRendererBase.java` file
- And the components `taglib.xml` documentation

Here is an example `tags.xml` file:

```
<?xml version='1.0' encoding='UTF-8'?>
<facelet-taglib>
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

The `tags.xml` file is required to be of the form `${shortNamespace}-tags.xml` (e.g. `alloy-tags.xml`).

The generator accepts certain elements as `taglib-extesion`s, `tag-extesions`s, and `attribute-extesions`s in order to obtain all the necessary information for generation and to reduce duplication. See each extension page for more details.