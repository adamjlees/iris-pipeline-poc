/// Methods to programmatically invoke zpm commands
Class Package.ManagePackages
{

/// Generate a module.xml file for zpm
ClassMethod Generate(name, version, description, keywords, folder As %String) As %Status
{
    /*  module.xml structure
    <?xml version="1.0" encoding="UTF-8"?>
    <Export generator="Cache" version="25">
        <Document name="irispipelinepoc.ZPM">
            <Module>
                <Name>{name}</Name>
                
                <Version>{version}</Version>
                <Description>{description}</Description>
                <Packaging>module</Packaging>   // hardcoded to "module"
                <Resource Name="Package1.PKG"/>  // list of resources - classes, class packages, globals etc.
                <Resource Name="Package2.PKG"/> //
                <SourcesRoot>src</SourcesRoot>
            </Module>
        </Document>
    </Export>
    
    https://community.intersystems.com/post/anatomy-zpm-module-packaging-your-intersystems-solution

    */ 
    set tsc=$$$OK
    set packaging="module" // hard coded value
    set resource1="Package",resource2="Build"

    if $EXTRACT(folder,$LENGTH(folder))="\" set folder=$EXTRACT(folder,1,$LENGTH(folder)-1) // strip a trailing backslash

    kill ^||TEMP // clear out per-process scratch global
    set sc=##class(Utils.File).SearchToGlb(folder,"*.*",1)    // List files in 'folder' to a scratch global

    set xml="<?xml version=""1.0"" encoding=""UTF-8""?><Export generator=""Cache"" version=""25""><Document name="""
    set xml=xml_name_".zpm""><Module><Name>"_name_"</Name>"
    set xml=xml_"<Version>"_version_"</Version>"
    set xml=xml_"<Description>"_description_"</Description>"
    set xml=xml_"<Packaging>"_packaging_"</Packaging>"
    set a=$ORDER(^||TEMP(""))
    while a'="" {
        if ^||TEMP(a)="D" { 
            set package=$PIECE(a,"\",$LENGTH(a,"\"))
            set xml=xml_"<Resource Name="""_package_".PKG""/>"
        } else {
            set xml=xml_"<Resource Name="""_^||TEMP(a)_"""/>"  // works if there are no other kinds of file in the folder except valid resources types, e.g .cls, .mac etc
        }
        set a=$ORDER(^||TEMP(a))
    } 
    set SourcesRoot=$PIECE(folder,"\",$LENGTH(folder,"\"))   // get off "src" folder
    set ModuleFolder=$PIECE(folder,"\",1,$LENGTH(folder,"\")-1)  // need folder above to put Module.xml
    set xml=xml_"<SourcesRoot>"_SourcesRoot_"</SourcesRoot>"
    set xml=xml_"</Module></Document></Export>"
    s ^ajltemp=xml
    set file=ModuleFolder_"\module.xml"
    w !,file
    open file:("WNS"):5
    use file
    write xml,!
    close file
    quit tsc
}

}
