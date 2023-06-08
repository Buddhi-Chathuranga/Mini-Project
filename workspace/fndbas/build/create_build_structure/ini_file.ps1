# uppelk

class Ini_Entry {
   [string]$key
   [string]$value

   # ctor
   Ini_Entry ( [string]$key, [string]$value ) {
      $this.key = $key
      $this.value = $value
   }

   [string]GetKey () {
      return $this.key
   }

   [string]GetValue () {
      return $this.value
   }
}

class Ini_Section {
   [string]$name
   [System.Collections.ArrayList]$items

   # ctor
   Ini_Section ( [string]$name ) {
      $this.name = $name
      $this.items = [System.Collections.ArrayList]::new()
   }

   Add ( [string]$key, [string]$value ) {
      $entry_ = [Ini_Entry]::new( $key, $value )
      $this.items.Add( $entry_ )
   }

   [bool]Exists ( [string]$key ) {
      foreach ( $s_ in $this.items ) {
         if ( $s_.key -eq $key ) {
            return $true
         }
      }
      return $false
   }
   
   [System.Collections.ArrayList]GetEntries() {
      return $this.items
   }
}

class Ini_File {

   [System.Collections.ArrayList]$items

   # ctor
   Ini_File ( [string] $file ) {

      $this.items = [System.Collections.ArrayList]::new()

      $CommentCount = 0
      [Ini_Section]$section = $null
      switch -regex -file $file  
      {  
         # Section
         "^\[(.+)\]$" {  
            $tmp_ = $matches[1]  
            [Ini_Section]$section = [Ini_Section]::new( [string]$tmp_ )
            $this.items.Add( $section )
            $CommentCount = 0
         }  
         # Comment
         "^(;.*)$" {  
            if (!($section)) {
               $section = [Ini_Section]::new( "no-section" )  
               $this.items.Add( $section )
            }  
            $value = $matches[1]  
            $CommentCount = $CommentCount + 1  
            $name = "Comment" + $CommentCount  
            $section.Add( $name, $value )  
         }
         # Key
         "(.+?)\s*=\s*(.*)" {
            if (!($section)) {  
               $section = [Ini_Section]::new( "no-section" )  
               $this.items.Add( $section )
            }  
            $name,$value = $matches[1..2]
            $section.Add( $name, $value )
        }
      }
   }

   [System.Collections.ArrayList]Items() {
      return $this.items
   }

   [Ini_Section]GetSection ( [string]$section ) {
      foreach ( $s_ in $this.items ) {
         if ( $s_.name -eq $section ) {
            return $s_
         }
      }
      return $null
   }
}