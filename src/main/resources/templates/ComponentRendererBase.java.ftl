<#include "./ComponentTemplateFunctions.ftl">
<#include "./ComponentRendererTemplateFunctions.ftl" />
<#if is_alloy(tag)>
<#include "./AlloyComponentRendererBase.java.ftl" />
<#else>
<@generate_copyright_header shortNamespace copyrightYear />
package ${get_component_package(tag["tag-name"])}.internal;
//J-

import javax.annotation.Generated;
<#if tag_is(tag, "generate-null-check-decode-method", false)>

import javax.faces.component.UIComponent;
import javax.faces.component.UIInput;
import javax.faces.context.FacesContext;
</#if>

<#-- If the class extends from a class with the same name, it must not import that class. -->
<#if get_unqualified_class_name(get_renderer_parent_class(tag)) != "${tag[\"tag-name\"]?cap_first}RendererBase">
import ${get_renderer_parent_class(tag)?keep_before("<")};
</#if>
<#if has_tag_extension(tag, "delegate-renderer-type")>

import ${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first};
</#if>


<#if authors??>
<@generate_authors authors />
</#if>
@Generated(value = "com.liferay.alloy.tools.builder.FacesBuilder")
public abstract class ${tag["tag-name"]?cap_first}RendererBase extends ${get_extends_class_name(get_renderer_parent_class(tag), "${tag[\"tag-name\"]?cap_first}RendererBase")} {
	<#assign first = true>
	<#list tag["attribute"]?sort_by("name") as attribute>
	<#if !attribute_is(attribute, "inherited", false)>
	<#if first>

	// Protected Constants
	</#if>
	protected static final String ${get_constant_string(attribute["name"])} = "${attribute["name"]}";
	<#assign first = false>
	</#if>
	</#list>
	<#if tag_is(tag, "generate-null-check-decode-method", false)>

<@generate_null_check_decode_method tag />
	</#if>
	<#if has_tag_extension(tag, "delegate-renderer-type")>

<@generate_delegate_getters tag />
	</#if>
}
//J+
</#if>