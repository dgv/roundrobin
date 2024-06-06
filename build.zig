const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("roundrobin", .{
        .root_source_file = b.path("src/roundrobin.zig"),
    });
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/roundrobin.zig"),
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
