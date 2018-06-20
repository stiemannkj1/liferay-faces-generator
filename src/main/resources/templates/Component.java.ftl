<#include "./ComponentTemplateFunctions.ftl">
<@generate_copyright_header shortNamespace copyrightYear />
package ${get_component_package(tag["tag-name"])};

import javax.faces.component.FacesComponent;

import org.osgi.annotation.versioning.ConsumerType;


<#if authors??>
<@generate_authors authors />
</#if>
@FacesComponent(value = ${tag["tag-name"]?cap_first}.COMPONENT_TYPE)
@ConsumerType
public class ${tag["tag-name"]?cap_first} extends ${tag["tag-name"]?cap_first}Base {
	// Initial Generation
}
