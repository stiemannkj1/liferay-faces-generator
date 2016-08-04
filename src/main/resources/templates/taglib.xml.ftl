<#include "./TemplateFunctions.ftl"/>
<#compress>

<#function format_java_types string_with_java_types>
	<#return remove_CDATA(string_with_java_types?xml)>
</#function>
</#compress>
<?xml version='1.0' encoding='UTF-8'?>
<#-- If the JSF version is 2.1, the Facelet Taglib version is 2.0. See -->
<#-- https://issues.liferay.com/browse/FACES-2109#commentauthor_590915_verbose for more details. -->
<#assign defaultXMLNamespace = "http://xmlns.jcp.org/xml/ns/javaee">
<#assign faceletTaglibVersion = facesSpecVersion>
<#assign vdldocNamespace = "http://vdldoc.omnifaces.org" />
<#if faceletTaglibVersion == "2.1" || faceletTaglibVersion == "2.0">
	<#assign defaultXMLNamespace = "http://java.sun.com/xml/ns/javaee" />
	<#assign faceletTaglibVersion = "2.0" />
</#if>
<#assign showcasePrefix = "${shortNamespace?lower_case}" />
<#if showcasePrefix == "portlet" || showcasePrefix == "bridge">
	<#assign showcasePrefix = "jsf" />
</#if>
<facelet-taglib xmlns="${defaultXMLNamespace}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:vdldoc="${vdldocNamespace}"
	xsi:schemaLocation="${defaultXMLNamespace} ${defaultXMLNamespace}/web-facelettaglibrary_${faceletTaglibVersion?replace(".", "_")}.xsd ${vdldocNamespace} https://raw.githubusercontent.com/omnifaces/vdldoc/master/src/main/resources/org/omnifaces/vdldoc/resources/vdldoc.taglib.xml.xsd"
	version="${faceletTaglibVersion}">
	<#if tagsDocument["facelet-taglib/description"][0]??>
	<description><![CDATA[${format_description(tagsDocument["facelet-taglib/description"])}]]></description>
	</#if>
	<namespace>${tagsDocument["facelet-taglib/namespace"]}</namespace>
	<#list tagsDocument["facelet-taglib/function"]?sort_by("function-name") as function>
	<function>
		<description><![CDATA[${format_description(function["description"])}]]></description>
		<function-name>${function["function-name"]}</function-name>
		<function-class>${format_java_types(function["function-class"])}</function-class>
		<function-signature>${format_java_types(function["function-signature"])}</function-signature>
	</function>
	</#list>
	<#list tagsDocument["facelet-taglib/tag"]?sort_by("tag-name") as tag>
	<#if tag_is(tag, "generate-taglib-xml", true)>
	<tag>
		<description><![CDATA[${format_description(tag["description"])}]]></description>
		<tag-name>${tag["tag-name"]}</tag-name>
		<#if tag["validator"][0]??>
		<validator>
			<validator-id>${tag["validator/validator-id"]}</validator-id>
		</validator>
		<#elseif tag_is(tag, "handler-class-only", false)>
		<handler-class>${tag["handler-class"]}</handler-class>
		<#else>
		<component>
			<component-type>${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first}</component-type>
			<#if tag_is(tag, "generate-renderer", true)>
			<renderer-type>${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first}Renderer</renderer-type>
			</#if>
			<#if tag["handler-class"][0]??>
			<handler-class>${tag["handler-class"]}</handler-class>
			</#if>
		</component>
		</#if>
		<#list tag["attribute"]?sort_by("name") as attribute>
		<attribute>
			<#if attribute["description"][0]??>
			<description><![CDATA[<#if has_attribute_extension(attribute, "deprecated")><strong>Deprecated.</strong> ${attribute["attribute-extension/deprecated"]} </#if>${format_description(attribute["description"])}<#if !(attribute["description"]?contains("default") || attribute["description"]?contains("Default")) && has_attribute_extension(attribute, "default-value")> The default value is <code>${attribute["attribute-extension/default-value"]}</code>.</#if><#if has_attribute_extension(attribute, "since")> Since: ${attribute["attribute-extension/since"]}</#if>]]></description>
			</#if>
			<name>${attribute["name"]}</name>
			<required><#if attribute["required"][0]??>${attribute["required"]}<#else>false</#if></required>
			<#if attribute["method-signature"][0]??>
			<method-signature>${format_java_types(attribute["method-signature"])}</method-signature>
			<#else>
			<type>${format_java_types(get_attribute_type(attribute))}</type>
			</#if>
		</attribute>
		</#list>
		<tag-extension>
			<vdldoc:example-url>http://www.liferayfaces.org/web/guest/${showcasePrefix}-showcase/-/${showcasePrefix}-tag/${shortNamespace?lower_case}/${tag["tag-name"]?lower_case}/general</vdldoc:example-url>
			<vdldoc:since>${get_tag_extension(tag, "since", defaultSince)}</vdldoc:since>
		</tag-extension>
	</tag>
	</#if>
</#list>
</facelet-taglib>
