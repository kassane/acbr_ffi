const std = @import("std");
const acbrNFE = @import("ACBrNFeImport.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();
    var acbr = try acbrNFE.init(allocator);
    defer acbr.deinit();

    try acbr.NFE_init("acbr_zig.ini", "");
    const nome = try acbr.nome();
    const version = try acbr.versao();

    acbrNFE.log.info("Nome: {s}", .{nome});
    acbrNFE.log.info("Versao: {s}", .{version});
}
