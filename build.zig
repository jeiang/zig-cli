const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zig_cli_module = b.addModule("zig-cli", .{
        .source_file = .{ .path = "src/main.zig" },
    });

    const lib_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/tests.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_lib_tests = b.addRunArtifact(lib_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_lib_tests.step);

    const simple = b.addExecutable(.{
        .name = "simple",
        .root_source_file = .{ .path = "example/simple.zig" },
        .target = target,
        .optimize = optimize,
    });
    simple.addModule("zig-cli", zig_cli_module);
    b.installArtifact(simple);

    const short = b.addExecutable(.{
        .name = "short",
        .root_source_file = .{ .path = "example/short.zig" },
        .target = target,
        .optimize = optimize,
    });
    short.addModule("zig-cli", zig_cli_module);
    b.installArtifact(short);

    b.default_step.dependOn(&simple.step);
    b.default_step.dependOn(&short.step);
}
