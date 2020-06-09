using NodeJS

function main()
    run(`$(npm_cmd()) config set scripts-prepent-node-path true`)
    run(`$(npm_cmd()) install -g electron@6.1.4 orca`)

    @show orca_cmd = "$(joinpath(dirname(npm_cmd().exec[1]), "orca"))"
    if Sys.iswindows()
        orca_cmd = string(orca_cmd, ".cmd")
    end

    # Docker creates a file /.dockerenv presence of which
    # is a indicator that the library is being called inside a container
    if isfile("/.dockerenv")
        xvfb_run=Sys.which("xvfb-run") # Find the path of xvfb-run binary
        if xvfb_run == nothing
            @warn("ORCA requires xvfb to function inside docker container")
            @info("In ubuntu install by executing apt-get install xvfb")
        else
            orca_cmd = xvfb_run * " " * orca_cmd
        end
    end

    open("paths.jl", "w") do f
        println(f, "# This file is automatically generated by build.jl DO NOT EDIT")
        println(f, "const orca_cmd = `\"$(orca_cmd)\"`")
    end
end

main()
