<#compress>
<#function format_description description>
	<#return remove_CDATA(description)?replace("\n|\t", "", "r") />
</#function>

<#function get_attribute_type attribute>
	<#local attribute_type = "java.lang.Object" />
	<#if attribute["method-signature"][0]??>
		<#local attribute_type = "javax.el.MethodExpression" />
	<#elseif attribute["type"][0]?? />
		<#local attribute_type = remove_CDATA(attribute["type"]) />
	</#if>
	<#return attribute_type />
</#function>

<#function get_component_package tag_name>
	<#local tag_name = tag_name?trim />
	<#return "com.liferay.faces.${shortNamespace}.component.${tag_name?lower_case}" />
</#function>

<#function get_attribute_extension attribute extension_name default="">
	<#return get_element_extension(attribute, "attribute", extension_name, default) />
</#function>

<#function get_element_extension element element_type extension_name default="">
	<#local extension_value = default />
	<#if has_extension(element, element_type, extension_name)>
		<#local extension_value = remove_CDATA(element["${element_type}-extension/${extension_name}"]) />
	</#if>
	<#return extension_value />
</#function>

<#function get_tag_extension tag extension_name default="">
	<#return get_element_extension(tag, "tag", extension_name, default) />
</#function>

<#function get_unqualified_class_name qualified_class_name>
	<#return qualified_class_name?keep_after_last(qualified_class_name?keep_before("<")?keep_before_last(".") + ".") />
</#function>

<#function has_attribute_extension attribute extension_name>
	<#return has_extension(attribute, "attribute", extension_name) />
</#function>

<#function has_extension element element_type extension_name>
	<#return element["${element_type}-extension"][0]?? && element["${element_type}-extension/${extension_name}"][0]?? />
</#function>

<#function has_tag_extension tag extension_name>
	<#return has_extension(tag, "tag", extension_name) />
</#function>

<#function remove_CDATA string_with_CDATA>
	<#return string_with_CDATA?trim?remove_beginning("<![CDATA[")?remove_ending("]]>") />
</#function>

<#function tag_is tag extension_name default>
	<#return (get_tag_extension(tag, extension_name, default?c)?lower_case == "true") />
</#function>
</#compress>