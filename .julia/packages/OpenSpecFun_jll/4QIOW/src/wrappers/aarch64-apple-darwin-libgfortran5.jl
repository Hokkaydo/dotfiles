# Autogenerated wrapper script for OpenSpecFun_jll for aarch64-apple-darwin-libgfortran5
export libopenspecfun

using CompilerSupportLibraries_jll
JLLWrappers.@generate_wrapper_header("OpenSpecFun")
JLLWrappers.@declare_library_product(libopenspecfun, "@rpath/libopenspecfun.2.dylib")
function __init__()
    JLLWrappers.@generate_init_header(CompilerSupportLibraries_jll)
    JLLWrappers.@init_library_product(
        libopenspecfun,
        "lib/libopenspecfun.2.1.dylib",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
