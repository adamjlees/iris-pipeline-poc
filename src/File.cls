/// File utilities
/// AJL 19/07/2012
Class Utils.File [ Abstract ]
{

ClassMethod Search(dir As %String, mask As %String, direntries As %Boolean) As %Status
{
    // define wildcard
    Set mask=$Get(mask, "*.*")
     
    // search passed-in directory for files matching wildcard
    Set fs=##class(%ResultSet).%New("%File:FileSet")
    Set sc=fs.Execute(dir, mask)
     
    While (fs.Next()) {
        // if sub-directory found then recurse
        If fs.Get("Type")="D" {
            Do ##class(Utils.File).Search(fs.Get("Name"), mask)
        } Else {
            Write !,fs.Get("Name"),?30, fs.Get("Type"), "  ", fs.Get("Size")
			/* Name = Full name with path
			   ItemName = filename without path
			   Type = file type
			   Size = size in bytes
			   DateCreated, DateModified = self explanatory (%TimeStamp format)
			*/
        }
    }
     
    Quit sc
}

/// Searches folders and subfolders for files matching search mask' and outputs them to a scratch global
/// dir = directory path to search
/// mask = e.g. "*.cls"
/// direntries = search and show directory names as well as files
ClassMethod SearchToGlb(dir As %String, mask As %String, direntries As %Boolean) As %Status
{
    // define wildcard
    Set mask=$Get(mask, "*.*"),direntries=$GET(direntries)
     
    // search passed-in directory for files matching wildcard
    Set fs=##class(%ResultSet).%New("%File:FileSet")
    Set sc=fs.Execute(dir, mask,,1)
     
    While (fs.Next()) {
		S name=fs.Get("Name")
		S itemname=fs.Get("ItemName")
		
        // if sub-directory found then recurse
        If fs.Get("Type")="D" {
            if direntries set ^||TEMP(name)="D"
            D ##class(Utils.File).SearchToGlb(name,mask)  
        } Else {
			S ^||TEMP(name)=itemname
		
        }
    }
     
    Quit sc
}

}
