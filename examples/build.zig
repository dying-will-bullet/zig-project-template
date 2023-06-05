const std = @import("std");

const pkg_name = "zig-project-template";
const pkg_path = "../src/lib.zig";

const examples = .{
    "default",
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    inline for (examples) |e| {
        const example_path = e ++ "/main.zig";
        const exe_name = "example-" ++ e;
        const run_name = "run-" ++ e;
        const run_desc = "Run the " ++ e ++ " example";

        const exe = b.addExecutable(.{
            .name = exe_name,
            .root_source_file = .{ .path = example_path },
            .target = target,
            .optimize = optimize,
        });
        const mod = b.addModule("zig-project-template", .{
            .source_file = .{ .path = "../src/lib.zig" },
        });
        exe.addModule("zig-project-template", mod);

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());
        const run_step = b.step(run_name, run_desc);
        run_step.dependOn(&run_cmd.step);
    }
}
