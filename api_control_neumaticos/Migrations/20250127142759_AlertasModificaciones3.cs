using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class AlertasModificaciones3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ALERTA_USUARIO_UsuarioAtendidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropForeignKey(
                name: "FK_ALERTA_USUARIO_UsuarioLeidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropIndex(
                name: "IX_ALERTA_UsuarioAtendidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropIndex(
                name: "IX_ALERTA_UsuarioLeidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "UsuarioAtendidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "UsuarioLeidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.CreateIndex(
                name: "IX_ALERTA_ID_USUARIO_ATENDIDO",
                table: "ALERTA",
                column: "ID_USUARIO_ATENDIDO");

            migrationBuilder.CreateIndex(
                name: "IX_ALERTA_ID_USUARIO_LEIDO",
                table: "ALERTA",
                column: "ID_USUARIO_LEIDO");

            migrationBuilder.AddForeignKey(
                name: "FK_ALERTA_USUARIO_ID_USUARIO_ATENDIDO",
                table: "ALERTA",
                column: "ID_USUARIO_ATENDIDO",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");

            migrationBuilder.AddForeignKey(
                name: "FK_ALERTA_USUARIO_ID_USUARIO_LEIDO",
                table: "ALERTA",
                column: "ID_USUARIO_LEIDO",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ALERTA_USUARIO_ID_USUARIO_ATENDIDO",
                table: "ALERTA");

            migrationBuilder.DropForeignKey(
                name: "FK_ALERTA_USUARIO_ID_USUARIO_LEIDO",
                table: "ALERTA");

            migrationBuilder.DropIndex(
                name: "IX_ALERTA_ID_USUARIO_ATENDIDO",
                table: "ALERTA");

            migrationBuilder.DropIndex(
                name: "IX_ALERTA_ID_USUARIO_LEIDO",
                table: "ALERTA");

            migrationBuilder.AddColumn<int>(
                name: "UsuarioAtendidoIdUsuario",
                table: "ALERTA",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsuarioLeidoIdUsuario",
                table: "ALERTA",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ALERTA_UsuarioAtendidoIdUsuario",
                table: "ALERTA",
                column: "UsuarioAtendidoIdUsuario");

            migrationBuilder.CreateIndex(
                name: "IX_ALERTA_UsuarioLeidoIdUsuario",
                table: "ALERTA",
                column: "UsuarioLeidoIdUsuario");

            migrationBuilder.AddForeignKey(
                name: "FK_ALERTA_USUARIO_UsuarioAtendidoIdUsuario",
                table: "ALERTA",
                column: "UsuarioAtendidoIdUsuario",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");

            migrationBuilder.AddForeignKey(
                name: "FK_ALERTA_USUARIO_UsuarioLeidoIdUsuario",
                table: "ALERTA",
                column: "UsuarioLeidoIdUsuario",
                principalTable: "USUARIO",
                principalColumn: "ID_USUARIO");
        }
    }
}
