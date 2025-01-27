using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class AlertasModificaciones : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "FECHA_ALERTA",
                table: "ALERTA",
                newName: "FECHA_INGRESO");

            migrationBuilder.AddColumn<int>(
                name: "ESTADO_ALERTA",
                table: "ALERTA",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "FECHA_ATENDIDO",
                table: "ALERTA",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "FECHA_LEIDO",
                table: "ALERTA",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ID_USUARIO_ATENDIDO",
                table: "ALERTA",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ID_USUARIO_LEIDO",
                table: "ALERTA",
                type: "int",
                nullable: true);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
                name: "ESTADO_ALERTA",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "FECHA_ATENDIDO",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "FECHA_LEIDO",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "ID_USUARIO_ATENDIDO",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "ID_USUARIO_LEIDO",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "UsuarioAtendidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.DropColumn(
                name: "UsuarioLeidoIdUsuario",
                table: "ALERTA");

            migrationBuilder.RenameColumn(
                name: "FECHA_INGRESO",
                table: "ALERTA",
                newName: "FECHA_ALERTA");
        }
    }
}
