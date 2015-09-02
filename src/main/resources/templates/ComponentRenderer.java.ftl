<#include "./ComponentTemplateFunctions.ftl">
<#include "./ComponentRendererTemplateFunctions.ftl" />
<@generate_copyright_header shortNamespace copyrightYear />
package ${get_component_package(tag["tag-name"])}.internal;

<#if is_alloy(tag)>
import javax.faces.application.ResourceDependencies;
</#if>
import javax.faces.render.FacesRenderer;

import ${get_component_package(tag["tag-name"])}.${tag["tag-name"]?cap_first};


<@generate_authors />
//J-
@FacesRenderer(componentFamily = ${tag["tag-name"]?cap_first}.COMPONENT_FAMILY, rendererType = ${tag["tag-name"]?cap_first}.RENDERER_TYPE)
<#if is_alloy(tag)>
@ResourceDependencies(
	{
		@ResourceDependency(library = "liferay-faces-reslib", name = "build/aui-css/css/bootstrap.min.css"),
		@ResourceDependency(library = "liferay-faces-reslib", name = "build/aui/aui-min.js"),
		@ResourceDependency(library = "liferay-faces-reslib", name = "liferay.js")
	}
)
</#if>
//J+
public class ${tag["tag-name"]?cap_first}Renderer extends ${tag["tag-name"]?cap_first}RendererBase {
	// Initial Generation
}
