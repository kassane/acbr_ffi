//! C header translated to zig API (v0.11.0 or higher) - ACBRlib [FFI]

const std = @import("std");
const builtin = @import("builtin");
pub const log = std.log.scoped(.ACBr);

const ACBr = @This();

dylib: std.DynLib,
handle: usize,
arena: std.heap.ArenaAllocator,

pub fn init(alloc: std.mem.Allocator) !ACBr {
    const libname = switch (builtin.os.tag) {
        .windows => switch (builtin.cpu.arch) {
            .x86_64 => "ACBrNFe64.dll",
            .x86 => "ACBrNFe32.dll",
            else => @compileError("Unsupported CPU Architecture"),
        },
        .linux => switch (builtin.cpu.arch) {
            .x86_64 => "libacbrnfe64.so",
            .x86 => "libacbrnfe32.so",
            else => @compileError("Unsupported CPU Architecture"),
        },
        else => @compileError("Unsupported OS"),
    };
    return .{ .dylib = try std.DynLib.open(libname), .arena = .{ .state = .{}, .child_allocator = alloc }, .handle = 0 };
}
pub fn NFE_init(self: *ACBr, config_path: CString, encrypt: CString) !void {
    const initFn = self.dylib.lookup(NFE_Inicializar, "NFE_Inicializar") orelse return error.SymbolNotFound;
    if (initFn(&self.handle, config_path, encrypt) == 0) {
        log.info("Initialize ACBrLib!!", .{});
    }
}
pub fn nome(self: *ACBr) ![]const u8 {
    const nomeFn = self.dylib.lookup(NFE_Nome, "NFE_Nome") orelse return error.SymbolNotFound;
    var buff: [15:0]u8 = undefined;
    var buff_size: c_int = @intCast(buff.len);
    if (nomeFn(self.handle, &buff, &buff_size) == 0) {
        return try std.fmt.allocPrint(self.arena.allocator(), "{s}", .{@as([*:0]const u8, @ptrCast(&buff))});
    } else return error.Unexpected;
}
pub fn versao(self: *ACBr) ![]const u8 {
    const versaoFn = self.dylib.lookup(NFE_Versao, "NFE_Versao") orelse return error.SymbolNotFound;
    var buff: [8:0]u8 = undefined;
    var buff_size: c_int = @intCast(buff.len);

    if (versaoFn(self.handle, &buff, &buff_size) == 0) {
        return try std.fmt.allocPrint(self.arena.allocator(), "{s}", .{@as([*:0]const u8, @ptrCast(&buff))});
    } else return error.Unexpected;
}
pub fn deinit(self: *ACBr) void {
    self.dylib.close();
    self.arena.deinit();
}

pub const NFE_Inicializar = *const fn (?*usize, CString, CString) callconv(.C) c_int;
pub const NFE_Finalizar = *const fn (usize) callconv(.C) c_int;
pub const NFE_Nome = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_Versao = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_UltimoRetorno = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_ConfigLer = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_ConfigGravar = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_ConfigLerValor = *const fn (usize, CString, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_ConfigGravarValor = *const fn (usize, CString, CString, CString) callconv(.C) c_int;
pub const NFE_ConfigImportar = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_ConfigExportar = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_CarregarXML = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_CarregarINI = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_ObterXml = *const fn (usize, c_int, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_GravarXml = *const fn (usize, c_int, CString, CString) callconv(.C) c_int;
pub const NFE_CarregarEventoXML = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_CarregarEventoINI = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_LimparLista = *const fn (usize) callconv(.C) c_int;
pub const NFE_LimparListaEventos = *const fn (usize) callconv(.C) c_int;
pub const NFE_Assinar = *const fn (usize) callconv(.C) c_int;
pub const NFE_Validar = *const fn (usize) callconv(.C) c_int;
pub const NFE_ValidarRegrasdeNegocios = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_VerificarAssinatura = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_GerarChave = *const fn (usize, c_int, c_int, c_int, c_int, c_int, c_int, CString, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_ObterCertificados = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_GetPath = *const fn (usize, c_int, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_GetPathEvento = *const fn (usize, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_StatusServico = *const fn (usize, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_Consultar = *const fn (usize, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_Inutilizar = *const fn (usize, CString, CString, c_int, c_int, c_int, c_int, c_int, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_Enviar = *const fn (usize, c_int, bool, bool, bool, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_ConsultarRecibo = *const fn (usize, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_Cancelar = *const fn (usize, CString, CString, CString, c_int, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_EnviarEvento = *const fn (usize, c_int, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_ConsultaCadastro = *const fn (usize, CString, CString, bool, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_DistribuicaoDFePorUltNSU = *const fn (usize, c_int, CString, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_DistribuicaoDFePorNSU = *const fn (usize, c_int, CString, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_DistribuicaoDFePorChave = *const fn (usize, c_int, CString, CString, CString, ?*c_int) callconv(.C) c_int;
pub const NFE_EnviarEmail = *const fn (usize, CString, CString, bool, CString, CString, CString, CString) callconv(.C) c_int;
pub const NFE_EnviarEmailEvento = *const fn (usize, CString, CString, CString, bool, CString, CString, CString, CString) callconv(.C) c_int;
pub const NFE_Imprimir = *const fn (usize, CString, c_int, CString, CString, CString, CString, CString) callconv(.C) c_int;
pub const NFE_ImprimirPDF = *const fn (usize) callconv(.C) c_int;
pub const NFE_ImprimirEvento = *const fn (usize, CString, CString) callconv(.C) c_int;
pub const NFE_ImprimirEventoPDF = *const fn (usize, CString, CString) callconv(.C) c_int;
pub const NFE_ImprimirInutilizacao = *const fn (usize, CString) callconv(.C) c_int;
pub const NFE_ImprimirInutilizacaoPDF = *const fn (usize, CString) callconv(.C) c_int;

// typedef
const CString = [*:0]const u8;
