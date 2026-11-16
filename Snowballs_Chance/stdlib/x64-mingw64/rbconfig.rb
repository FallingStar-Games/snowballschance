# encoding: ascii-8bit
# frozen-string-literal: false
#
# The module storing Ruby interpreter configurations on building.
#
# This file was created by mkconfig.rb when ruby was built.  It contains
# build information for ruby which is used e.g. by mkmf to build
# compatible native extensions.  Any changes made to this file will be
# lost the next time ruby is built.

module RbConfig
  RUBY_VERSION.start_with?("3.1.") or
    raise "ruby lib version (3.1.3) doesn't match executable version (#{RUBY_VERSION})"

  # Ruby installed directory.
  TOPDIR = File.dirname(__FILE__).chomp!("lib/ruby/3.1.0/x64-mingw64")
  # DESTDIR on make install.
  DESTDIR = '' unless defined? DESTDIR
  # The hash configurations stored.
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["MAJOR"] = "3"
  CONFIG["MINOR"] = "1"
  CONFIG["TEENY"] = "3"
  CONFIG["PATCHLEVEL"] = "185"
  CONFIG["INSTALL"] = '/usr/bin/install -c'
  CONFIG["EXEEXT"] = ".exe"
  CONFIG["prefix"] = (TOPDIR || DESTDIR + "/")
  CONFIG["ruby_install_name"] = "$(RUBY_BASE_NAME)"
  CONFIG["RUBY_INSTALL_NAME"] = "$(RUBY_BASE_NAME)"
  CONFIG["RUBY_SO_NAME"] = "ruby"
  CONFIG["exec"] = "exec"
  CONFIG["ruby_pc"] = "ruby-3.1.pc"
  CONFIG["CC_WRAPPER"] = ""
  CONFIG["PACKAGE"] = "ruby"
  CONFIG["BUILTIN_TRANSSRCS"] = " enc/trans/newline.c"
  CONFIG["MKMF_VERBOSE"] = "1"
  CONFIG["MANTYPE"] = "doc"
  CONFIG["vendorarchhdrdir"] = "$(vendorhdrdir)/$(sitearch)"
  CONFIG["sitearchhdrdir"] = "$(sitehdrdir)/$(sitearch)"
  CONFIG["rubyarchhdrdir"] = "$(DESTDIR)/include"
  CONFIG["vendorhdrdir"] = "$(rubyhdrdir)/vendor_ruby"
  CONFIG["sitehdrdir"] = "$(rubyhdrdir)/site_ruby"
  CONFIG["rubyhdrdir"] = "$(DESTDIR)/include"
  CONFIG["RUBY_SEARCH_PATH"] = ""
  CONFIG["UNIVERSAL_INTS"] = ""
  CONFIG["UNIVERSAL_ARCHNAMES"] = ""
  CONFIG["configure_args"] = " '--srcdir=/home/runner/work/mkxp-z/mkxp-z/subprojects/ruby-3_1_3' '--prefix=/home/runner/work/mkxp-z/mkxp-z/build/artifact' '--prefix=/' '--bindir=/home/runner/work/mkxp-z/mkxp-z/build/artifact/bin' '--bindir=/bin' '--libdir=/home/runner/work/mkxp-z/mkxp-z/build/artifact/lib' '--libdir=/lib' '--includedir=/home/runner/work/mkxp-z/mkxp-z/build/artifact/include' '--includedir=/include' '--with-rubyhdrdir=/include' '--with-rubyarchhdrdir=/include' '--with-destdir=/home/runner/work/mkxp-z/mkxp-z/build/subprojects/ruby-3_1_3/dist' '--with-baseruby=/usr/bin/ruby' '--with-soname=ruby' '--disable-shared' '--disable-install-doc' '--without-ext=openssl,readline,dbm,gdbm' '--with-static-linked-ext' '--disable-rubygems' '--without-gmp' '--enable-mkmf-verbose' 'CC=/usr/bin/ccache x86_64-w64-mingw32-gcc -D_WIN32_WINNT=0x0601' 'CXX=/usr/bin/ccache x86_64-w64-mingw32-g++ -D_WIN32_WINNT=0x0601' 'AR=/usr/bin/x86_64-w64-mingw32-ar' 'RANLIB=/usr/bin/x86_64-w64-mingw32-ar s' 'AS=false' 'LD=false' 'NM=false' 'OBJCOPY=false' 'OBJDUMP=false' 'STRIP=false' 'CFLAGS=-std=gnu11 -O3 -fPIC -flto=auto -fdiagnostics-color=always -fno-sanitize=address -I/home/runner/work/mkxp-z/mkxp-z/subprojects/zlib-1.3.1 -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1/__CMake_build -I/home/runner/work/mkxp-z/mkxp-z/subprojects/libyaml/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml/__CMake_build/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/include' 'CXXFLAGS=-std=gnu++14 -O3 -fPIC -flto=auto -fdiagnostics-color=always -fno-sanitize=address -I/home/runner/work/mkxp-z/mkxp-z/subprojects/zlib-1.3.1 -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1/__CMake_build -I/home/runner/work/mkxp-z/mkxp-z/subprojects/libyaml/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml/__CMake_build/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/include' 'LDFLAGS=-fuse-ld=bfd -flto=auto -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1 -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/lib' '--host=x86_64-pc-windows' '--host=x86_64-unknown-mingw64' 'host_alias=x86_64-unknown-mingw64'"
  CONFIG["CONFIGURE"] = "configure"
  CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(sitearch)"
  CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
  CONFIG["vendordir"] = "$(rubylibprefix)/vendor_ruby"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["sitedir"] = "$(rubylibprefix)/site_ruby"
  CONFIG["rubyarchdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["rubylibdir"] = "$(rubylibprefix)/$(ruby_version)"
  CONFIG["ruby_version"] = "3.1.0"
  CONFIG["sitearch"] = "x64-msvcrt"
  CONFIG["arch"] = "x64-mingw64"
  CONFIG["sitearchincludedir"] = "$(includedir)/$(sitearch)"
  CONFIG["archincludedir"] = "$(includedir)/$(arch)"
  CONFIG["sitearchlibdir"] = "$(libdir)/$(sitearch)"
  CONFIG["archlibdir"] = "$(libdir)/$(arch)"
  CONFIG["libdirname"] = "libdir"
  CONFIG["RUBY_EXEC_PREFIX"] = ""
  CONFIG["RUBY_LIB_VERSION"] = ""
  CONFIG["RUBY_LIB_VERSION_STYLE"] = "3\t/* full */"
  CONFIG["RI_BASE_NAME"] = "ri"
  CONFIG["ridir"] = "$(datarootdir)/$(RI_BASE_NAME)"
  CONFIG["rubysitearchprefix"] = "$(rubylibprefix)/$(sitearch)"
  CONFIG["rubyarchprefix"] = "$(rubylibprefix)/$(arch)"
  CONFIG["MAKEFILES"] = "Makefile GNUmakefile"
  CONFIG["PLATFORM_DIR"] = "win32"
  CONFIG["THREAD_MODEL"] = "win32"
  CONFIG["SYMBOL_PREFIX"] = ""
  CONFIG["EXPORT_PREFIX"] = " "
  CONFIG["COMMON_HEADERS"] = "winsock2.h windows.h"
  CONFIG["COMMON_MACROS"] = ""
  CONFIG["COMMON_LIBS"] = "m"
  CONFIG["MAINLIBS"] = "-lz -lshell32 -lws2_32 -liphlpapi -limagehlp -lshlwapi -lbcrypt -Wl,-Bstatic -lgcc -lpthread -Wl,-Bdynamic "
  CONFIG["ENABLE_SHARED"] = "no"
  CONFIG["DLDSHARED"] = "$(CC) -shared"
  CONFIG["DLDLIBS"] = ""
  CONFIG["SOLIBS"] = "$(MAINLIBS)"
  CONFIG["LIBRUBYARG_SHARED"] = ""
  CONFIG["LIBRUBYARG_STATIC"] = "-l$(RUBY_SO_NAME)-static $(MAINLIBS)"
  CONFIG["LIBRUBYARG"] = "$(MISSING) $(LIBRUBYARG_STATIC)"
  CONFIG["LIBRUBY"] = "lib$(RUBY_SO_NAME).a"
  CONFIG["LIBRUBY_ALIASES"] = ""
  CONFIG["LIBRUBY_SONAME"] = "lib$(RUBY_SO_NAME).$(SOEXT).$(RUBY_API_VERSION)"
  CONFIG["LIBRUBY_SO"] = "dummy"
  CONFIG["LIBRUBY_A"] = "lib$(RUBY_SO_NAME)-static.a"
  CONFIG["RUBYW_INSTALL_NAME"] = "$(RUBYW_BASE_NAME)"
  CONFIG["rubyw_install_name"] = "$(RUBYW_INSTALL_NAME)"
  CONFIG["EXTDLDFLAGS"] = "$(DEFFILE)"
  CONFIG["EXTLDFLAGS"] = "-static-libgcc"
  CONFIG["strict_warnflags"] = ""
  CONFIG["warnflags"] = "-Wall -Wextra -Wdeprecated-declarations -Wduplicated-cond -Wimplicit-function-declaration -Wimplicit-int -Wmisleading-indentation -Wpointer-arith -Wwrite-strings -Wold-style-definition -Wimplicit-fallthrough=0 -Wmissing-noreturn -Wno-cast-function-type -Wno-constant-logical-operand -Wno-long-long -Wno-missing-field-initializers -Wno-overlength-strings -Wno-packed-bitfield-compat -Wno-parentheses-equality -Wno-self-assign -Wno-tautological-compare -Wno-unused-parameter -Wno-unused-value -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wunused-variable -Wundef"
  CONFIG["debugflags"] = "-ggdb3"
  CONFIG["optflags"] = "-O3 -fno-omit-frame-pointer -fno-fast-math"
  CONFIG["NULLCMD"] = ":"
  CONFIG["ENABLE_DEBUG_ENV"] = ""
  CONFIG["DLNOBJ"] = "dln.o"
  CONFIG["INSTALL_STATIC_LIBRARY"] = "yes"
  CONFIG["MJIT_SUPPORT"] = "yes"
  CONFIG["EXECUTABLE_EXTS"] = ".exe .com .cmd .bat"
  CONFIG["ARCHFILE"] = ""
  CONFIG["LIBRUBY_RELATIVE"] = "yes"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["PREP"] = "$(arch)-fake.rb"
  CONFIG["CROSS_COMPILING"] = "yes"
  CONFIG["TEST_RUNNABLE"] = "no"
  CONFIG["rubylibprefix"] = "$(libdir)/$(RUBY_BASE_NAME)"
  CONFIG["setup"] = "Setup"
  CONFIG["ENCSTATIC"] = "static"
  CONFIG["EXTSTATIC"] = "static"
  CONFIG["SOEXT"] = "dll"
  CONFIG["TRY_LINK"] = ""
  CONFIG["PRELOADENV"] = ""
  CONFIG["LIBPATHENV"] = "PATH"
  CONFIG["RPATHFLAG"] = ""
  CONFIG["LIBPATHFLAG"] = " -L%s"
  CONFIG["LINK_SO"] = ""
  CONFIG["ADDITIONAL_DLDFLAGS"] = ""
  CONFIG["ASMEXT"] = "S"
  CONFIG["LIBEXT"] = "a"
  CONFIG["DLEXT"] = "so"
  CONFIG["LDSHAREDXX"] = "$(CXX) -shared"
  CONFIG["LDSHARED"] = "$(CC) -shared"
  CONFIG["CCDLFLAGS"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["DLDFLAGS"] = "-fuse-ld=bfd -flto=auto -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1 -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/lib -Wl,--enable-auto-image-base,--enable-auto-import"
  CONFIG["ALLOCA"] = ""
  CONFIG["dsymutil"] = ""
  CONFIG["codesign"] = ""
  CONFIG["cleanlibs"] = ""
  CONFIG["POSTLINK"] = ":"
  CONFIG["WERRORFLAG"] = "-Werror"
  CONFIG["CHDIR"] = "cd -P"
  CONFIG["RMALL"] = "rm -fr"
  CONFIG["RMDIRS"] = "rmdir --ignore-fail-on-non-empty -p"
  CONFIG["RMDIR"] = "rmdir --ignore-fail-on-non-empty"
  CONFIG["CP"] = "cp"
  CONFIG["RM"] = "rm -f"
  CONFIG["PKG_CONFIG"] = "pkg-config"
  CONFIG["YACC"] = "/usr/bin/bison"
  CONFIG["DOXYGEN"] = ""
  CONFIG["DOT"] = ""
  CONFIG["MAKEDIRS"] = "/usr/bin/mkdir -p"
  CONFIG["MKDIR_P"] = "/usr/bin/mkdir -p"
  CONFIG["INSTALL_DATA"] = "$(INSTALL) -m 644"
  CONFIG["INSTALL_SCRIPT"] = "$(INSTALL)"
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["SET_MAKE"] = ""
  CONFIG["LN_S"] = "ln -s"
  CONFIG["DLLWRAP"] = "false"
  CONFIG["WINDRES"] = "x86_64-w64-mingw32-windres -D_WIN32_WINNT=0x0601"
  CONFIG["ASFLAGS"] = ""
  CONFIG["ARFLAGS"] = "rcD "
  CONFIG["try_header"] = ""
  CONFIG["CC_VERSION_MESSAGE"] = "x86_64-w64-mingw32-gcc (GCC) 13-win32\nCopyright (C) 2023 Free Software Foundation, Inc.\nThis is free software; see the source for copying conditions.  There is NO\nwarranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
  CONFIG["CC_VERSION"] = "$(CC) --version"
  CONFIG["MJIT_CC"] = "/usr/bin/ccache x86_64-w64-mingw32-gcc -D_WIN32_WINNT=0x0601"
  CONFIG["CSRCFLAG"] = ""
  CONFIG["COUTFLAG"] = "-o "
  CONFIG["OUTFLAG"] = "-o "
  CONFIG["MKXP_DISABLE_LTO_FOR_LINK_TESTS"] = "no"
  CONFIG["CPPOUTFILE"] = "-o conftest.i"
  CONFIG["GNU_LD"] = "yes"
  CONFIG["GCC"] = "yes"
  CONFIG["CPP"] = "$(CC) -E"
  CONFIG["CXXFLAGS"] = "-std=gnu++14 -O3 -fPIC -flto=auto -fdiagnostics-color=always -fno-sanitize=address -I/home/runner/work/mkxp-z/mkxp-z/subprojects/zlib-1.3.1 -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1/__CMake_build -I/home/runner/work/mkxp-z/mkxp-z/subprojects/libyaml/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml/__CMake_build/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/include"
  CONFIG["OBJEXT"] = "o"
  CONFIG["CPPFLAGS"] = "-D__MINGW_USE_VC2005_COMPAT $(DEFS) $(cppflags)"
  CONFIG["LDFLAGS"] = "-L. -fuse-ld=bfd -flto=auto -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1 -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml -L/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/lib"
  CONFIG["CFLAGS"] = "-std=gnu11 -O3 -fPIC -flto=auto -fdiagnostics-color=always -fno-sanitize=address -I/home/runner/work/mkxp-z/mkxp-z/subprojects/zlib-1.3.1 -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/zlib-1.3.1/__CMake_build -I/home/runner/work/mkxp-z/mkxp-z/subprojects/libyaml/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libyaml/__CMake_build/include -I/home/runner/work/mkxp-z/mkxp-z/build/subprojects/libffi-3.5.2/dist/include"
  CONFIG["STRIP"] = "false"
  CONFIG["RANLIB"] = "/usr/bin/x86_64-w64-mingw32-ar s"
  CONFIG["OBJDUMP"] = "false"
  CONFIG["OBJCOPY"] = ":"
  CONFIG["NM"] = "false"
  CONFIG["LD"] = "false"
  CONFIG["CXX"] = "/usr/bin/ccache x86_64-w64-mingw32-g++ -D_WIN32_WINNT=0x0601"
  CONFIG["AS"] = "false"
  CONFIG["AR"] = "/usr/bin/x86_64-w64-mingw32-ar"
  CONFIG["CC"] = "/usr/bin/ccache x86_64-w64-mingw32-gcc -D_WIN32_WINNT=0x0601"
  CONFIG["target_os"] = "mingw64"
  CONFIG["target_vendor"] = "unknown"
  CONFIG["target_cpu"] = "x64"
  CONFIG["target"] = "x86_64-unknown-mingw64"
  CONFIG["host_os"] = "mingw64"
  CONFIG["host_vendor"] = "unknown"
  CONFIG["host_cpu"] = "x64"
  CONFIG["host"] = "x86_64-unknown-mingw64"
  CONFIG["build_os"] = "linux-gnu"
  CONFIG["build_vendor"] = "pc"
  CONFIG["build_cpu"] = "x86_64"
  CONFIG["build"] = "x86_64-pc-linux-gnu"
  CONFIG["RUBY_VERSION_NAME"] = "$(RUBY_BASE_NAME)-$(ruby_version)"
  CONFIG["RUBYW_BASE_NAME"] = "rubyw"
  CONFIG["RUBY_BASE_NAME"] = "ruby"
  CONFIG["RUBY_PROGRAM_VERSION"] = "$(MAJOR).$(MINOR).$(TEENY)"
  CONFIG["RUBY_API_VERSION"] = "$(MAJOR).$(MINOR)"
  CONFIG["HAVE_GIT"] = "yes"
  CONFIG["GIT"] = "git"
  CONFIG["cxxflags"] = ""
  CONFIG["cppflags"] = ""
  CONFIG["cflags"] = "$(optflags) $(debugflags) $(warnflags)"
  CONFIG["ECHO_T"] = ""
  CONFIG["ECHO_N"] = "-n"
  CONFIG["ECHO_C"] = ""
  CONFIG["target_alias"] = ""
  CONFIG["host_alias"] = ""
  CONFIG["build_alias"] = ""
  CONFIG["LIBS"] = "-lshell32 -lws2_32 -liphlpapi -limagehlp -lshlwapi -lbcrypt -Wl,-Bstatic -lgcc -lpthread -Wl,-Bdynamic "
  CONFIG["DEFS"] = "-D_FILE_OFFSET_BITS=64"
  CONFIG["mandir"] = "$(datarootdir)/man"
  CONFIG["localedir"] = "$(datarootdir)/locale"
  CONFIG["libdir"] = "$(exec_prefix)lib"
  CONFIG["psdir"] = "$(docdir)"
  CONFIG["pdfdir"] = "$(docdir)"
  CONFIG["dvidir"] = "$(docdir)"
  CONFIG["htmldir"] = "$(docdir)"
  CONFIG["infodir"] = "$(datarootdir)/info"
  CONFIG["docdir"] = "$(datarootdir)/doc/$(PACKAGE)"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["includedir"] = "$(exec_prefix)include"
  CONFIG["runstatedir"] = "$(localstatedir)/run"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["sysconfdir"] = "$(DESTDIR)"
  CONFIG["datadir"] = "$(datarootdir)"
  CONFIG["datarootdir"] = "$(prefix)/share"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["bindir"] = "$(exec_prefix)bin"
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["PACKAGE_URL"] = ""
  CONFIG["PACKAGE_BUGREPORT"] = ""
  CONFIG["PACKAGE_STRING"] = ""
  CONFIG["PACKAGE_VERSION"] = ""
  CONFIG["PACKAGE_TARNAME"] = ""
  CONFIG["PACKAGE_NAME"] = ""
  CONFIG["PATH_SEPARATOR"] = ":"
  CONFIG["SHELL"] = "/bin/bash"
  CONFIG["UNICODE_VERSION"] = "13.0.0"
  CONFIG["UNICODE_EMOJI_VERSION"] = "13.1"
  CONFIG["platform"] = "$(arch)"
  CONFIG["archdir"] = "$(rubyarchdir)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  # Almost same with CONFIG. MAKEFILE_CONFIG has other variable
  # reference like below.
  #
  #   MAKEFILE_CONFIG["bindir"] = "$(exec_prefix)/bin"
  #
  # The values of this constant is used for creating Makefile.
  #
  #   require 'rbconfig'
  #
  #   print <<-END_OF_MAKEFILE
  #   prefix = #{RbConfig::MAKEFILE_CONFIG['prefix']}
  #   exec_prefix = #{RbConfig::MAKEFILE_CONFIG['exec_prefix']}
  #   bindir = #{RbConfig::MAKEFILE_CONFIG['bindir']}
  #   END_OF_MAKEFILE
  #
  #   => prefix = /usr/local
  #      exec_prefix = $(prefix)
  #      bindir = $(exec_prefix)/bin  MAKEFILE_CONFIG = {}
  #
  # RbConfig.expand is used for resolving references like above in rbconfig.
  #
  #   require 'rbconfig'
  #   p RbConfig.expand(RbConfig::MAKEFILE_CONFIG["bindir"])
  #   # => "/usr/local/bin"
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}

  # call-seq:
  #
  #   RbConfig.expand(val)         -> string
  #   RbConfig.expand(val, config) -> string
  #
  # expands variable with given +val+ value.
  #
  #   RbConfig.expand("$(bindir)") # => /home/foobar/all-ruby/ruby19x/bin
  def RbConfig::expand(val, config = CONFIG)
    newval = val.gsub(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) {
      var = $&
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	config[v] = RbConfig::expand(key, config)
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    }
    val.replace(newval) unless newval == val
    val
  end
  CONFIG.each_value do |val|
    RbConfig::expand(val)
  end

  # :nodoc:
  # call-seq:
  #
  #   RbConfig.fire_update!(key, val)               -> array
  #   RbConfig.fire_update!(key, val, mkconf, conf) -> array
  #
  # updates +key+ in +mkconf+ with +val+, and all values depending on
  # the +key+ in +mkconf+.
  #
  #   RbConfig::MAKEFILE_CONFIG.values_at("CC", "LDSHARED") # => ["gcc", "$(CC) -shared"]
  #   RbConfig::CONFIG.values_at("CC", "LDSHARED")          # => ["gcc", "gcc -shared"]
  #   RbConfig.fire_update!("CC", "gcc-8")                  # => ["CC", "LDSHARED"]
  #   RbConfig::MAKEFILE_CONFIG.values_at("CC", "LDSHARED") # => ["gcc-8", "$(CC) -shared"]
  #   RbConfig::CONFIG.values_at("CC", "LDSHARED")          # => ["gcc-8", "gcc-8 -shared"]
  #
  # returns updated keys list, or +nil+ if nothing changed.
  def RbConfig.fire_update!(key, val, mkconf = MAKEFILE_CONFIG, conf = CONFIG)
    return if mkconf[key] == val
    mkconf[key] = val
    keys = [key]
    deps = []
    begin
      re = Regexp.new("\\$\\((?:%1$s)\\)|\\$\\{(?:%1$s)\\}" % keys.join('|'))
      deps |= keys
      keys.clear
      mkconf.each {|k,v| keys << k if re =~ v}
    end until keys.empty?
    deps.each {|k| conf[k] = mkconf[k].dup}
    deps.each {|k| expand(conf[k])}
    deps
  end

  # call-seq:
  #
  #   RbConfig.ruby -> path
  #
  # returns the absolute pathname of the ruby command.
  def RbConfig.ruby
    File.join(
      RbConfig::CONFIG["bindir"],
      RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
    )
  end
end
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
