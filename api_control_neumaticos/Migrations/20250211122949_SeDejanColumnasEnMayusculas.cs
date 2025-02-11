using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class SeDejanColumnasEnMayusculas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "ContraseñaTemporal",
                table: "USUARIO",
                newName: "CONTRASENA_TEMPORAL");

            migrationBuilder.RenameColumn(
                name: "Estado",
                table: "SOLICITUD_CORREOS",
                newName: "ESTADO");

            migrationBuilder.AlterColumn<string>(
                name: "CONTRASENA_TEMPORAL",
                table: "USUARIO",
                type: "nvarchar(max)",
                nullable: false,
                defaultValueSql: "((0))",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CONTRASENA_TEMPORAL",
                table: "USUARIO",
                newName: "ContraseñaTemporal");

            migrationBuilder.RenameColumn(
                name: "ESTADO",
                table: "SOLICITUD_CORREOS",
                newName: "Estado");

            migrationBuilder.AlterColumn<string>(
                name: "ContraseñaTemporal",
                table: "USUARIO",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldDefaultValueSql: "((0))");
        }
    }
}
