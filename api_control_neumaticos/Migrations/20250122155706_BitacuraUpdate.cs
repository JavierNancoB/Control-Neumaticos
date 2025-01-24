using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class BitacuraUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BITACORA_NEUMATICO_NEUMATICOS_IDNeumatico",
                table: "BITACORA_NEUMATICO");

            migrationBuilder.DropForeignKey(
                name: "FK_BITACORA_NEUMATICO_USUARIO_IDUsuario",
                table: "BITACORA_NEUMATICO");

            migrationBuilder.RenameColumn(
                name: "IDUsuario",
                table: "BITACORA_NEUMATICO",
                newName: "ID_USUARIO");

            migrationBuilder.RenameColumn(
                name: "IDNeumatico",
                table: "BITACORA_NEUMATICO",
                newName: "ID_NEUMATICO");

            migrationBuilder.RenameIndex(
                name: "IX_BITACORA_NEUMATICO_IDUsuario",
                table: "BITACORA_NEUMATICO",
                newName: "IX_BITACORA_NEUMATICO_ID_USUARIO");

            migrationBuilder.RenameIndex(
                name: "IX_BITACORA_NEUMATICO_IDNeumatico",
                table: "BITACORA_NEUMATICO",
                newName: "IX_BITACORA_NEUMATICO_ID_NEUMATICO");

            migrationBuilder.AddForeignKey(
                name: "FK_BITACORA_NEUMATICO_NEUMATICOS_ID_NEUMATICO",
                table: "BITACORA_NEUMATICO",
                column: "ID_NEUMATICO",
                principalTable: "NEUMATICOS",
                principalColumn: "ID_NEUMATICO");

            migrationBuilder.AddForeignKey(
                name: "FK_BITACORA_NEUMATICO_USUARIO_ID_USUARIO",
                table: "BITACORA_NEUMATICO",
                column: "ID_USUARIO",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BITACORA_NEUMATICO_NEUMATICOS_ID_NEUMATICO",
                table: "BITACORA_NEUMATICO");

            migrationBuilder.DropForeignKey(
                name: "FK_BITACORA_NEUMATICO_USUARIO_ID_USUARIO",
                table: "BITACORA_NEUMATICO");

            migrationBuilder.RenameColumn(
                name: "ID_USUARIO",
                table: "BITACORA_NEUMATICO",
                newName: "IDUsuario");

            migrationBuilder.RenameColumn(
                name: "ID_NEUMATICO",
                table: "BITACORA_NEUMATICO",
                newName: "IDNeumatico");

            migrationBuilder.RenameIndex(
                name: "IX_BITACORA_NEUMATICO_ID_USUARIO",
                table: "BITACORA_NEUMATICO",
                newName: "IX_BITACORA_NEUMATICO_IDUsuario");

            migrationBuilder.RenameIndex(
                name: "IX_BITACORA_NEUMATICO_ID_NEUMATICO",
                table: "BITACORA_NEUMATICO",
                newName: "IX_BITACORA_NEUMATICO_IDNeumatico");

            migrationBuilder.AddForeignKey(
                name: "FK_BITACORA_NEUMATICO_NEUMATICOS_IDNeumatico",
                table: "BITACORA_NEUMATICO",
                column: "IDNeumatico",
                principalTable: "NEUMATICOS",
                principalColumn: "ID_NEUMATICO");

            migrationBuilder.AddForeignKey(
                name: "FK_BITACORA_NEUMATICO_USUARIO_IDUsuario",
                table: "BITACORA_NEUMATICO",
                column: "IDUsuario",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");
        }
    }
}
