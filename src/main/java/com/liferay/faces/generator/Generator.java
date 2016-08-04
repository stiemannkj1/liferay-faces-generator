/**
 * Copyright (c) 2000-2015 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
package com.liferay.faces.generator;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.NoSuchElementException;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import org.xml.sax.SAXException;

import freemarker.ext.dom.NodeModel;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;


/**
 * @author  Kyle Stiemann
 */
public final class Generator {

	private Configuration configuration;
	private DocumentBuilder documentBuilder;
	private Map<String, Tag> commonComponentsMap;

	private Generator() {

		this.configuration = createConfiguration();
		this.documentBuilder = createDocumentBuilder();
		this.commonComponentsMap = createCommonComponentsMap(documentBuilder);
	}

	public static void main(String[] args) throws FileNotFoundException, IOException {

		Generator generator = new Generator();

		for (String arg : args) {
			generator.generateComponents(arg);
		}
	}

	private void addExtensionAttributes(Tag tag, Map<String, Tag> tagMap, Document document) {

		List<String> extendsTagsNames = tag.getExtendsTags();

		for (String extendedTagName : extendsTagsNames) {

			Tag extendedTag = tagMap.get(extendedTagName);

			if ((extendedTag == null) && extendedTagName.endsWith("Inherited")) {

				int extendedTagNameLength = extendedTagName.length();
				int inheritedLength = "Inherited".length();
				String inheritedExtendedTagName = extendedTagName.substring(0, extendedTagNameLength - inheritedLength);
				extendedTag = tagMap.get(inheritedExtendedTagName);
			}

			if (extendedTag == null) {

				String tagName = tag.getTagName();
				throw new NoSuchElementException(tagName + " extends non-existent tag " + extendedTagName);
			}

			addExtensionAttributes(extendedTag, tagMap, document);
			tag.addExtendedComponentAttributes(extendedTag, document, extendedTagName.endsWith("Inherited"));
		}
	}

	private Map<String, Tag> createCommonComponentsMap(DocumentBuilder documentBuilder) {

		InputStream commonComponentsInputStream = getClass().getResourceAsStream("/common-tags.xml");
		Map<String, Tag> commonComponentsMap = new HashMap<String, Tag>();
		Document document = null;

		try {
			document = documentBuilder.parse(commonComponentsInputStream);
		}
		catch (Exception e) {
			throw new RuntimeException(e);
		}

		Node documentNode = document.getDocumentElement();
		NodeList childNodes = documentNode.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			String nodeName = childNode.getNodeName();

			if (nodeName.equals("tag")) {

				Tag tag = new Tag(childNode);
				commonComponentsMap.put(tag.getTagName(), tag);
			}
		}

		Set<Entry<String, Tag>> commonComponentsEntrySet = commonComponentsMap.entrySet();

		for (Entry<String, Tag> commonTagEntry : commonComponentsEntrySet) {

			Tag tag = commonTagEntry.getValue();
			addExtensionAttributes(tag, commonComponentsMap, document);
			tag.removeExtendsTags();
		}

		return Collections.unmodifiableMap(commonComponentsMap);
	}

	private Configuration createConfiguration() {

		Configuration configuration = new Configuration(Configuration.VERSION_2_3_23);
		configuration.setClassForTemplateLoading(getClass(), "/templates");
		configuration.setTemplateUpdateDelayMilliseconds(Long.MAX_VALUE);
		configuration.setTemplateExceptionHandler(TemplateExceptionHandler.DEBUG_HANDLER);

		return configuration;
	}

	private DocumentBuilder createDocumentBuilder() {

		DocumentBuilder documentBuilder;
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();

		try {
			documentBuilder = dbFactory.newDocumentBuilder();
		}
		catch (ParserConfigurationException e) {
			throw new RuntimeException(e);
		}

		return documentBuilder;
	}

	private void generateComponentFile(String directoryPath, String shortNamespace, Tag tag, String componentFileType,
		Map<String, Object> freemarkerProperties) throws IOException {

		StringBuilder componentFilePathStringBuilder = new StringBuilder();
		componentFilePathStringBuilder.append(directoryPath);
		componentFilePathStringBuilder.append("/");
		componentFilePathStringBuilder.append(shortNamespace);
		componentFilePathStringBuilder.append("/component/");

		String lowerCaseTagName = tag.getTagName().toLowerCase();
		componentFilePathStringBuilder.append(lowerCaseTagName);
		componentFilePathStringBuilder.append("/");

		if (componentFileType.contains("Renderer")) {
			componentFilePathStringBuilder.append("internal/");
		}

		String tagName = tag.getTagName();
		String capitalizedTagName = tagName.substring(0, 1).toUpperCase() + tagName.substring(1);
		componentFilePathStringBuilder.append(capitalizedTagName);

		String componentFileSuffix = componentFileType.replace("Component", "");
		componentFilePathStringBuilder.append(componentFileSuffix);
		componentFilePathStringBuilder.append(".java");

		String templateName = componentFileType + ".java.ftl";

		generateFile(componentFilePathStringBuilder.toString(), freemarkerProperties, templateName,
			componentFileType.contains("Base"));
	}

	private void generateComponents(String tagsFilePath) throws FileNotFoundException, IOException {

		File file = new File(tagsFilePath);

		if (!file.exists()) {
			throw new FileNotFoundException(tagsFilePath + " not found.");
		}

		if (!file.isFile()) {
			throw new IllegalArgumentException(tagsFilePath + " is not a file.");
		}

		if (!file.canRead()) {
			throw new IllegalArgumentException(tagsFilePath + " is not a readable file.");
		}

		String fileName = file.getName();
		String shortNamespace = fileName.replace("-tags.xml", "");
		Map<String, Object> freemarkerProperties = new HashMap<String, Object>();
		freemarkerProperties.put("shortNamespace", shortNamespace);

		Document document = null;

		try {
			document = documentBuilder.parse(file);
		}
		catch (SAXException e) {
			throw new IllegalArgumentException(tagsFilePath + " is not a valid xml file.", e);
		}

		Map<String, Tag> tagMap = new HashMap<String, Tag>();
		tagMap.putAll(commonComponentsMap);

		boolean taglibExtensionElementExists = false;
		String componentOutpoutDirectoryPath = null;
		String componentInternalOutpoutDirectoryPath = null;
		String taglibXMLOuputDirectoryPath = null;
		Node documentNode = document.getDocumentElement();
		NodeList childNodes = documentNode.getChildNodes();
		int totalChildNodes = childNodes.getLength();

		for (int i = 0; i < totalChildNodes; i++) {

			Node childNode = childNodes.item(i);
			String nodeName = childNode.getNodeName();

			if (nodeName.equals("tag")) {

				Tag tag = new Tag(childNode);
				tagMap.put(tag.getTagName(), tag);
			}
			else if (nodeName.equals("taglib-extension")) {

				taglibExtensionElementExists = true;
				componentOutpoutDirectoryPath = GeneratorUtil.getNodeContents("component-output-directory", childNode);

				if ((componentOutpoutDirectoryPath == null) || componentOutpoutDirectoryPath.equals("")) {
					throw new NullPointerException("<component-output-directory> must be specified.");
				}

				componentInternalOutpoutDirectoryPath = GeneratorUtil.getNodeContents(
						"component-internal-output-directory", childNode);

				if ((componentInternalOutpoutDirectoryPath == null) ||
						componentInternalOutpoutDirectoryPath.equals("")) {
					componentInternalOutpoutDirectoryPath = componentOutpoutDirectoryPath;
				}

				taglibXMLOuputDirectoryPath = GeneratorUtil.getNodeContents("taglib-xml-output-directory", childNode);

				if ((taglibXMLOuputDirectoryPath == null) || taglibXMLOuputDirectoryPath.equals("")) {
					throw new NullPointerException("<taglib-xml-output-directory> must be specified.");
				}

				String authorsString = GeneratorUtil.getNodeContents("authors", childNode);

				if ((authorsString != null) && !authorsString.equals("")) {

					String[] authorsArray = authorsString.split(",");
					List<String> authors = new ArrayList<String>();

					for (String author : authorsArray) {

						String trimmedAuthor = author.trim();
						authors.add(trimmedAuthor);
					}

					if (!authors.isEmpty()) {
						freemarkerProperties.put("authors", authors);
					}
				}

				String copyrightYear = GeneratorUtil.getNodeContents("copyright-year", childNode);

				if ((copyrightYear == null) || copyrightYear.equals("")) {

					GregorianCalendar calendar = new GregorianCalendar();
					int year = calendar.get(Calendar.YEAR);
					copyrightYear = String.valueOf(year);
				}

				freemarkerProperties.put("copyrightYear", copyrightYear);

				String defaultSince = GeneratorUtil.getNodeContents("default-since", childNode);

				if (defaultSince == null) {
					defaultSince = "1.0.0";
				}

				freemarkerProperties.put("defaultSince", defaultSince);

				String facesSpecVersion = GeneratorUtil.getNodeContents("faces-spec-version", childNode);

				if ((facesSpecVersion == null) || facesSpecVersion.equals("")) {
					facesSpecVersion = "2.0";
				}

				freemarkerProperties.put("facesSpecVersion", facesSpecVersion);
			}
		}

		if (!taglibExtensionElementExists) {
			throw new NullPointerException("<taglib-extension> must be specified.");
		}

		Set<Entry<String, Tag>> tagMapEntrySet = tagMap.entrySet();

		for (Entry<String, Tag> tagEntry : tagMapEntrySet) {

			Tag tag = (Tag) tagEntry.getValue();
			addExtensionAttributes(tag, tagMap, document);

			if (tag.isGenerateJava() && (tag.isGenerateComponent() || tag.isGenerateRenderer())) {

				NodeModel tagNodeModel = tag.getTagNodeModel();
				freemarkerProperties.put("tag", tagNodeModel);

				if (tag.isGenerateComponent()) {

					generateComponentFile(componentOutpoutDirectoryPath, shortNamespace, tag, "Component",
						freemarkerProperties);
					generateComponentFile(componentOutpoutDirectoryPath, shortNamespace, tag, "ComponentBase",
						freemarkerProperties);
				}

				if (tag.isGenerateRenderer()) {

					generateComponentFile(componentInternalOutpoutDirectoryPath, shortNamespace, tag,
						"ComponentRenderer", freemarkerProperties);
					generateComponentFile(componentInternalOutpoutDirectoryPath, shortNamespace, tag,
						"ComponentRendererBase", freemarkerProperties);
				}
			}
		}

		freemarkerProperties.remove("tag");

		NodeModel tagsDocumentNodeModel = NodeModel.wrap(document);
		freemarkerProperties.put("tagsDocument", tagsDocumentNodeModel);

		StringBuilder taglibXMLFilePathStringBuilder = new StringBuilder();
		taglibXMLFilePathStringBuilder.append(taglibXMLOuputDirectoryPath);
		taglibXMLFilePathStringBuilder.append("/");
		taglibXMLFilePathStringBuilder.append(shortNamespace);
		taglibXMLFilePathStringBuilder.append(".taglib.xml");

		generateFile(taglibXMLFilePathStringBuilder.toString(), freemarkerProperties, "taglib.xml.ftl", true);
	}

	private void generateFile(String filePath, Map<String, Object> freemarkerProperties, String templateName,
		boolean overwriteFile) throws IOException {

		File file = new File(filePath);
		boolean fileExists = file.exists();

		if (!fileExists || overwriteFile) {

			StringWriter stringWriter = new StringWriter();
			Template template = null;

			try {
				template = configuration.getTemplate(templateName);
			}
			catch (IOException e) {
				throw new RuntimeException(e);
			}

			try {
				template.process(freemarkerProperties, stringWriter);
			}
			catch (TemplateException e) {
				throw new RuntimeException(e);
			}

			String templateResults = stringWriter.toString();
			String fileContents = null;

			if (fileExists) {
				fileContents = FileUtils.readFileToString(file, StandardCharsets.UTF_8);
			}

			if (!templateResults.equals(fileContents)) {

				System.out.println("Writing " + file);
				FileUtils.writeStringToFile(file, templateResults, StandardCharsets.UTF_8);
			}
		}
	}
}
