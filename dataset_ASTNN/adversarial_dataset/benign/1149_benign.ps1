

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

 -||-> Describe "SemanticVersion api tests" -Tags 'CI' {
     -||-> Context "Constructing valid versions" {
         -||-> It "String argument constructor" {
             -||-> $v = [SemanticVersion]::new("1.2.3-Alpha-super.3+BLD.a1-xxx.03") <-||- 
             -||-> $v.Major | Should -Be 1 <-||- 
             -||-> $v.Minor | Should -Be 2 <-||- 
             -||-> $v.Patch | Should -Be 3 <-||- 
             -||-> $v.PreReleaseLabel | Should -Be "Alpha-super.3" <-||- 
             -||-> $v.BuildLabel | Should -Be "BLD.a1-xxx.03" <-||- 
             -||-> $v.ToString() | Should -Be "1.2.3-Alpha-super.3+BLD.a1-xxx.03" <-||- 

             -||-> $v = [SemanticVersion]::new("1.0.0") <-||- 
             -||-> $v.Major | Should -Be 1 <-||- 
             -||-> $v.Minor | Should -Be 0 <-||- 
             -||-> $v.Patch | Should -Be 0 <-||- 
             -||-> $v.PreReleaseLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.BuildLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.ToString() | Should -Be "1.0.0" <-||- 

             -||-> $v = [SemanticVersion]::new("3.0") <-||- 
             -||-> $v.Major | Should -Be 3 <-||- 
             -||-> $v.Minor | Should -Be 0 <-||- 
             -||-> $v.Patch | Should -Be 0 <-||- 
             -||-> $v.PreReleaseLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.BuildLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.ToString() | Should -Be "3.0.0" <-||- 

             -||-> $v = [SemanticVersion]::new("2") <-||- 
             -||-> $v.Major | Should -Be 2 <-||- 
             -||-> $v.Minor | Should -Be 0 <-||- 
             -||-> $v.Patch | Should -Be 0 <-||- 
             -||-> $v.PreReleaseLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.BuildLabel | Should -BeNullOrEmpty <-||- 
             -||-> $v.ToString() | Should -Be "2.0.0" <-||- 
        } <-||- 

        

         -||-> It "Int args constructor" {
             -||-> $v = [SemanticVersion]::new(1, 0, 0) <-||- 
             -||-> $v.ToString() | Should -Be "1.0.0" <-||- 

             -||-> $v = [SemanticVersion]::new(3, 2, 0, "beta.1") <-||- 
             -||-> $v.ToString() | Should -Be "3.2.0-beta.1" <-||- 

             -||-> $v = [SemanticVersion]::new(3, 2, 0, "beta.1+meta") <-||- 
             -||-> $v.ToString() | Should -Be "3.2.0-beta.1+meta" <-||- 

             -||-> $v = [SemanticVersion]::new(3, 2, 0, "beta.1", "meta") <-||- 
             -||-> $v.ToString() | Should -Be "3.2.0-beta.1+meta" <-||- 

             -||-> $v = [SemanticVersion]::new(3, 1) <-||- 
             -||-> $v.ToString() | Should -Be "3.1.0" <-||- 

             -||-> $v = [SemanticVersion]::new(3) <-||- 
             -||-> $v.ToString() | Should -Be "3.0.0" <-||- 
        } <-||- 

         -||-> It "Version arg constructor" {
             -||-> $v = [SemanticVersion]::new([Version]::new(1, 2)) <-||- 
             -||-> $v.ToString() | Should -Be '1.2.0' <-||- 

             -||-> $v = [SemanticVersion]::new([Version]::new(1, 2, 3)) <-||- 
             -||-> $v.ToString() | Should -Be '1.2.3' <-||- 
        } <-||- 

         -||-> It "Can covert to 'Version' type" {
             -||-> $v1 = [SemanticVersion]::new(3, 2, 1, "prerelease", "meta") <-||- 
             -||-> $v2 = [Version]$v1 <-||- 
             -||-> $v2.GetType() | Should -BeExactly "version" <-||- 
             -||-> $v2.PSobject.TypeNames[0] | Should -Be "System.Version
            $v2.Major | Should -Be 3
            $v2.Minor | Should -Be 2
            $v2.Build | Should -Be 1
            $v2.PSSemVerPreReleaseLabel | Should -Be "prerelease"
            $v2.PSSemVerBuildLabel | Should -Be "meta"
            $v2.ToString() | Should -Be "3.2.1-prerelease+meta"
        }

        It "Semantic version can round trip through version" {
            $v1 = [SemanticVersion]::new(3, 2, 1, "prerelease", "meta")
            $v2 = [SemanticVersion]::new([Version]$v1)
            $v2.ToString() | Should -Be "3.2.1-prerelease+meta"
        }
    }

    Context "Comparisons" {
        BeforeAll {
            $v1_0_0 = [SemanticVersion]::new(1, 0, 0)
            $v1_1_0 = [SemanticVersion]::new(1, 1, 0)
            $v1_1_1 = [SemanticVersion]::new(1, 1, 1)
            $v2_1_0 = [SemanticVersion]::new(2, 1, 0)
            $v1_0_0_alpha = [SemanticVersion]::new(1, 0, 0, "alpha.1.1")
            $v1_0_0_alpha2 = [SemanticVersion]::new(1, 0, 0, "alpha.1.2")
            $v1_0_0_beta = [SemanticVersion]::new(1, 0, 0, "beta")
            $v1_0_0_betaBuild = [SemanticVersion]::new(1, 0, 0, "beta", "BUILD")

            $testCases = @(
                @{ lhs = $v1_0_0; rhs = $v1_1_0 }
                @{ lhs = $v1_0_0; rhs = $v1_1_1 }
                @{ lhs = $v1_1_0; rhs = $v1_1_1 }
                @{ lhs = $v1_0_0; rhs = $v2_1_0 }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0_beta }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0_alpha2 }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0 }
                @{ lhs = $v1_0_0_beta; rhs = $v1_0_0 }
                @{ lhs = $v2_1_0; rhs = "3.0" }
                @{ lhs = "1.5"; rhs = $v2_1_0 }
            )
        }

        It "Build meta should be ignored" {
            $v1_0_0_beta -eq $v1_0_0_betaBuild | Should -BeTrue
            $v1_0_0_betaBuild -lt $v1_0_0_beta | Should -BeFalse
            $v1_0_0_beta -lt $v1_0_0_betaBuild | Should -BeFalse
        }

        It "<lhs> less than <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -lt $rhs | Should -BeTrue
            $rhs -lt $lhs | Should -BeFalse
        }

        It "<lhs> less than or equal <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -le $rhs | Should -BeTrue
            $rhs -le $lhs | Should -BeFalse
            $lhs -le $lhs | Should -BeTrue
            $rhs -le $rhs | Should -BeTrue
        }

        It "<lhs> greater than <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -gt $rhs | Should -BeFalse
            $rhs -gt $lhs | Should -BeTrue
        }

        It "<lhs> greater than or equal <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -ge $rhs | Should -BeFalse
            $rhs -ge $lhs | Should -BeTrue
            $lhs -ge $lhs | Should -BeTrue
            $rhs -ge $rhs | Should -BeTrue
        }

        It "Equality <operand>" -TestCases @(
            @{ operand = $v1_0_0 }
            @{ operand = $v1_0_0_alpha }
        ) {
            param($operand)
            $operand -eq $operand | Should -BeTrue
            $operand -ne $operand | Should -BeFalse
            $null -eq $operand | Should -BeFalse
            $operand -eq $null | Should -BeFalse
            $null -ne $operand | Should -BeTrue
            $operand -ne $null | Should -BeTrue
        }

        It "comparisons with null" {
            $v1_0_0 -lt $null | Should -BeFalse
            $null -lt $v1_0_0 | Should -BeTrue
            $v1_0_0 -le $null | Should -BeFalse
            $null -le $v1_0_0 | Should -BeTrue
            $v1_0_0 -gt $null | Should -BeTrue
            $null -gt $v1_0_0 | Should -BeFalse
            $v1_0_0 -ge $null | Should -BeTrue
            $null -ge $v1_0_0 | Should -BeFalse
        }
    }

    Context "Error handling" {

        It "<name>: '<version>'" -TestCases @(
            @{ name = "Missing parts: 'null'"; errorId = "PSArgumentNullException"; expectedResult = $false; version = $null }
            @{ name = "Missing parts: 'NullString'"; errorId = "PSArgumentNullException"; expectedResult = $false; version = [NullString]::Value }
            @{ name = "Missing parts: 'EmptyString'"; errorId = "FormatException"; expectedResult = $false; version = "" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "-alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1..0" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.-alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.+alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-alpha+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0+-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = ".0.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "-1.0.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "1.-1.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "1.0.-1" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "aa.0.0" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "1.bb.0" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "1.0.cc" }
        ) {
            param($version, $expectedResult, $errorId)
            { [SemanticVersion]::new($version) } | Should -Throw -ErrorId $errorId
            if ([LanguagePrimitives]::IsNull($version)) {
                
                { [SemanticVersion]::Parse($version) } | Should -Throw -ErrorId "FormatException"
            }
            else {
                { [SemanticVersion]::Parse($version) } | Should -Throw -ErrorId $errorId
            }
            $semVer = $null
            [SemanticVersion]::TryParse($_, [ref]$semVer) | Should -Be $expectedResult
            $semVer | Should -BeNullOrEmpty
        }

        It "Negative version arguments" {
            { [SemanticVersion]::new(-1, 0) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new(1, -1) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new(1, 1, -1) } | Should -Throw -ErrorId "PSArgumentException"
        }

        It "Incompatible 'Version' throws" {
            
            { [SemanticVersion]::new([Version]::new(0, 0, 0, 4)) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new([Version]::new("1.2.3.4")) } | Should -Throw -ErrorId "PSArgumentException"
        }
    }

    Context "Serialization" {
        $testCases = @(
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0"; semver = [SemanticVersion]::new(1, 0, 0) }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.1"; semver = [SemanticVersion]::new(1, 0, 1) }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0-alpha"; semver = [SemanticVersion]::new(1, 0, 0, "alpha") }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0-Alpha-super.3+BLD.a1-xxx.03"; semver = [SemanticVersion]::new(1, 0, 0, "Alpha-super.3+BLD.a1-xxx.03") }
        )
        It "Can round trip: <semver>" -TestCases $testCases {
            param($semver, $expectedResult)

            $ser = [PSSerializer]::Serialize($semver)
            $des = [PSSerializer]::Deserialize($ser)

            $des | Should -BeOfType System.Object
            $des.ToString() | Should -Be $expectedResult
        }
    }

    Context "Formatting" {
        It "Should not throw when default format-table is used" {
            { $PSVersionTable.PSVersion | Format-Table | Out-String } | Should -Not -Throw
        }
    }
}

 <-||-  <-||-  <-||-  <-||- 
