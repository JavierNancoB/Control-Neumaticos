using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class AddBitacoraAndAlerta : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "TIPO_MOVIL",
                table: "MOVIL",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "PATENTE",
                table: "MOVIL",
                type: "char(6)",
                unicode: false,
                fixedLength: true,
                maxLength: 6,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "char(6)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 6,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "MODELO",
                table: "MOVIL",
                type: "char(50)",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "char(50)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "MARCA",
                table: "MOVIL",
                type: "char(50)",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "char(50)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "EJES",
                table: "MOVIL",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.CreateTable(
                name: "ALERTA",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ID_NEUMATICO = table.Column<int>(type: "int", nullable: false),
                    FECHA_ALERTA = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CODIGO_ALERTA = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__ALERTA__3214EC07", x => x.ID);
                    table.ForeignKey(
                        name: "FK_ALERTA_NEUMATICOS_ID_NEUMATICO",
                        column: x => x.ID_NEUMATICO,
                        principalTable: "NEUMATICOS",
                        principalColumn: "ID_NEUMATICO");
                });

            migrationBuilder.CreateTable(
                name: "BITACORA_NEUMATICO",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IDNeumatico = table.Column<int>(type: "int", nullable: false),
                    IDUsuario = table.Column<int>(type: "int", nullable: false),
                    CODIGO = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FECHA = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ESTADO = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    OBSERVACION = table.Column<string>(type: "nvarchar(250)", maxLength: 250, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BITACORA_NEUMATICO", x => x.ID);
                    table.ForeignKey(
                        name: "FK_BITACORA_NEUMATICO_NEUMATICOS_IDNeumatico",
                        column: x => x.IDNeumatico,
                        principalTable: "NEUMATICOS",
                        principalColumn: "ID_NEUMATICO");
                    table.ForeignKey(
                        name: "FK_BITACORA_NEUMATICO_USUARIO_IDUsuario",
                        column: x => x.IDUsuario,
                        principalTable: "USUARIO",
                        principalColumn: "ID_USUARIO");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ALERTA_ID_NEUMATICO",
                table: "ALERTA",
                column: "ID_NEUMATICO");

            migrationBuilder.CreateIndex(
                name: "IX_BITACORA_NEUMATICO_IDNeumatico",
                table: "BITACORA_NEUMATICO",
                column: "IDNeumatico");

            migrationBuilder.CreateIndex(
                name: "IX_BITACORA_NEUMATICO_IDUsuario",
                table: "BITACORA_NEUMATICO",
                column: "IDUsuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ALERTA");

            migrationBuilder.DropTable(
                name: "BITACORA_NEUMATICO");

            migrationBuilder.AlterColumn<int>(
                name: "TIPO_MOVIL",
                table: "MOVIL",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "PATENTE",
                table: "MOVIL",
                type: "char(6)",
                unicode: false,
                fixedLength: true,
                maxLength: 6,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "char(6)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 6);

            migrationBuilder.AlterColumn<string>(
                name: "MODELO",
                table: "MOVIL",
                type: "char(50)",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "char(50)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "MARCA",
                table: "MOVIL",
                type: "char(50)",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "char(50)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<int>(
                name: "EJES",
                table: "MOVIL",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");
        }
    }
}
