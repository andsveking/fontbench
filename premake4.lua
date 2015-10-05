-- A solution contains projects, and defines the available configurations
solution "fontbench"
   configurations { "Debug", "Release" }
   location "build"
   targetdir "bin"
   debugdir "./"
   platforms { "x32", "x64" }


   project "fontbench_stb"
      language "C++"
      files { "src/**.h", "src/*.cpp" }

      includedirs { "libs/GLFW/include/",
                    "libs/GLEW/include/",
                    "libs/stb/"
                  }

      links { "stb", "GLFW", "GLEW" }

      if os.get() == "windows" then
         links { "opengl32",
                 -- "libs/luajit/win/x86/lua51",
                 -- "libs/luajit/win/x86_64/lua51"
               }
      elseif (os.get() == "macosx") then
        -- links { "libs/luajit/osx/x86_64/lua51" }
        links { "Cocoa.framework" }
        links { "IOKit.framework" }
        links { "CoreFoundation.framework" }
        links { "CoreVideo.framework" }
        links { "OpenGL.framework" }

        buildoptions { "-Wall", "-Werror" }
        -- linkoptions { "-pagezero_size 10000", "-image_base 100000000"}
      end

      configuration "Debug"
         kind "ConsoleApp"
         defines { "DEBUG" }
         flags { "Symbols" }

      configuration "Release"
         kind "WindowedApp"
         defines { "NDEBUG" }
         flags { "Optimize", "StaticRuntime" }

    project "stb"
        targetname ("stb_internal")
        kind "StaticLib"
        language "C"

        includedirs { "libs/stb/"}
        files { "libs/stb/*.c" }

        if os.get() == "windows" then
          defines { "_CRT_SECURE_NO_WARNINGS" }
        end
        configuration "Debug"
          defines { "DEBUG" }
          flags { "Symbols", "ExtraWarnings"}

        configuration "Release"
          defines { "NDEBUG" }
          flags { "Optimize", "ExtraWarnings", "StaticRuntime"}

   -- GLFW 3.1.0
   -- ==============
   -- Third party lib: http://www.glfw.org/
   -- 'GLFW is an Open Source, multi-platform library for
   --  creating windows with OpenGL contexts and receiving
   --  input and events. It is easy to integrate into
   --  existing applications and does not lay claim to the
   --  main loop.'
   project "GLFW"
      targetname ("glfw_internal")
      kind "StaticLib"
      language "C"
      -- files { "libs/GLFW/**.h", "libs/GLFW/**.c" }
      files { "libs/GLFW/**.h" }
      files { "libs/GLFW/src/context.c",
              "libs/GLFW/src/init.c",
              "libs/GLFW/src/input.c",
              "libs/GLFW/src/monitor.c",
              "libs/GLFW/src/window.c" }

      defines { "_GLFW_USE_OPENGL" }
      defines { "_GLFW_USE_CHDIR" }

      if os.get() == "windows" then
          -- defines { "_GLFW_USE_DWM_SWAP_INTERVAL" } -- "Set swap interval even when DWM compositing is enabled"
          -- defines { "_GLFW_USE_OPTIMUS_HPG" } -- "Force use of high-performance GPU on Optimus systems"

         defines { "_WIN32" }
         defines { "_GLFW_WGL" }
         defines { "_GLFW_WIN32" }
         files { "libs/GLFW/src/win32_init.c",
                 "libs/GLFW/src/win32_monitor.c",
                 "libs/GLFW/src/win32_time.c",
                 "libs/GLFW/src/win32_tls.c",
                 "libs/GLFW/src/win32_window.c",
                 "libs/GLFW/src/wgl_context.c",
                 "libs/GLFW/src/winmm_joystick.c" }
         buildoptions { "/wd4996" }

         links { "opengl32" }
      elseif (os.get() == "macosx") then
        defines { "_GLFW_USE_RETINA" }
        defines { "_GLFW_COCOA" }
        defines { "_GLFW_NSGL" }
        files { "libs/GLFW/src/cocoa_init.m",
                "libs/GLFW/src/cocoa_monitor.m",
                "libs/GLFW/src/mach_time.c",
                "libs/GLFW/src/posix_tls.c",
                "libs/GLFW/src/cocoa_window.m",
                "libs/GLFW/src/nsgl_context.m",
                "libs/GLFW/src/iokit_joystick.m" }

         buildoptions { "-fno-common" }
      end

      -- print("os.get(): " .. os.get() )

    -- set(glfw_HEADERS ${common_HEADERS} win32_platform.h win32_tls.h
    --                  winmm_joystick.h)
    -- set(glfw_SOURCES ${common_SOURCES} win32_init.c win32_monitor.c win32_time.c
    --                  win32_tls.c win32_window.c winmm_joystick.c)

      configuration "Debug"
         defines { "DEBUG" }
         flags { "Symbols" }

      configuration "Release"
         defines { "NDEBUG" }
         flags { "Optimize", "StaticRuntime" }

   -- GLEW 1.11.0
   -- ==============
   -- Third party lib: http://glew.sourceforge.net/
   -- 'The OpenGL Extension Wrangler Library (GLEW) is a cross-platform
   --  open-source C/C++ extension loading library. GLEW provides efficient
   --  run-time mechanisms for determining which OpenGL extensions are
   --  supported on the target platform.'
   project "GLEW"
      targetname ("glew_internal")
      kind "StaticLib"
      language "C"
      files { "libs/GLEW/**.h", "libs/GLEW/src/glew.c" }

      includedirs { "libs/GLEW/include/" }

      defines { "GLEW_STATIC", "_LIB" }
      if os.get() == "windows" then
         defines { "WIN32", "WIN32_LEAN_AND_MEAN", "VC_EXTRALEAN" }
         -- links { "opengl32" }
      end

      configuration "Debug"
         defines { "DEBUG" }
         flags { "Symbols" }

      configuration "Release"
         defines { "NDEBUG" }
         flags { "StaticRuntime" }
