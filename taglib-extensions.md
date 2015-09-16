# `taglib-extension`s

| `taglib- extension` Name | Description | Required | Default Value |
|--------------------------|-------------|----------|---------------|
| `authors` | The `<authors>` element specifies a comma separated list of the author names that will be generated in each component's JavaDoc header. | No | None |
| `component- internal- output- directory` | The `<component-internal-output-directory>` element specifies the full path to the folder where `ComponentRenderer.java` and `ComponentRendererBase.java` files will be generated. | No | Defaults to the value of `component- output- directory`. |
| `component- output- directory` | The `<component-output-directory>` element specifies the full path to the folder where `Component.java` and `ComponentBase.java` files will be generated. | Yes | None |
| `copyright- year` | The `<copyright-year>` element specifies the year which will be output in each Java file's copyright header | No | Defaults to the current year. |
| `default- since` | The `<default-since>` element specifies the default value which will be output for each component's [`<vdldoc:since>`](https://github.com/omnifaces/vdldoc/wiki/vdldoc:since) element. This value can be overridden in the `since` element of a tag's `tag-extension` | No | `1.0.0` |
| `faces- spec- version` | The `<faces-spec-version>` element specifies the JSF specification version. It is used to generate the `taglib.xml`'s `<faclet-taglib>` element with the correct namespaces and versions specified. | No | `2.0` |
| `taglib- xml- output- directory` | The `<taglib-xml-output-directory>` element specifies the fill file path to the folder where the `taglib.xml` file will be generated. | Yes | None |
