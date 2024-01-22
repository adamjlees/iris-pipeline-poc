Class Build.ProcessFile Extends Ens.BusinessService
{

/// Process a file in the folder
Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(pInput As %Stream.FileCharacter, pOutput As %RegisteredObject) As %Status
{
    set tsc=$$$OK

    Q tsc
}

}
