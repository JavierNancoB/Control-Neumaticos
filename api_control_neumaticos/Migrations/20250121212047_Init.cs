using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class Init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BODEGA",
                columns: table => new
                {
                    ID_BODEGA = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NOMBRE_BODEGA = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__BODEGA__3F5C45522D15E7A1", x => x.ID_BODEGA);
                });

            migrationBuilder.CreateTable(
                name: "TABLA",
                columns: table => new
                {
                    COD_TABLA = table.Column<int>(type: "int", nullable: false),
                    CODIGO = table.Column<int>(type: "int", nullable: false),
                    DESCRIPCION = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    ESTADO = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__TABLA__B22008D28B9CFED8", x => new { x.COD_TABLA, x.CODIGO });
                });

            migrationBuilder.CreateTable(
                name: "MOVIL",
                columns: table => new
                {
                    ID_MOVIL = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PATENTE = table.Column<string>(type: "char(6)", unicode: false, fixedLength: true, maxLength: 6, nullable: true),
                    MARCA = table.Column<string>(type: "char(50)", unicode: false, fixedLength: true, maxLength: 50, nullable: true),
                    MODELO = table.Column<string>(type: "char(50)", unicode: false, fixedLength: true, maxLength: 50, nullable: true),
                    EJES = table.Column<int>(type: "int", nullable: true),
                    TIPO_MOVIL = table.Column<int>(type: "int", nullable: true),
                    ID_BODEGA = table.Column<int>(type: "int", nullable: true),
                    CANTIDAD_NEUMATICOS = table.Column<int>(type: "int", nullable: true),
                    ESTADO = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__MOVIL__CEA90288602B00B0", x => x.ID_MOVIL);
                    table.ForeignKey(
                        name: "FK_MOVIL_BODEGA_ID_BODEGA",
                        column: x => x.ID_BODEGA,
                        principalTable: "BODEGA",
                        principalColumn: "ID_BODEGA");
                });

            migrationBuilder.CreateTable(
                name: "USUARIO",
                columns: table => new
                {
                    ID_USUARIO = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NOMBRES = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    APELLIDOS = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    CORREO = table.Column<string>(type: "nvarchar(320)", maxLength: 320, nullable: false),
                    CLAVE = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    CODIGO_PERFIL = table.Column<int>(type: "int", nullable: false),
                    COD_ESTADO = table.Column<int>(type: "int", nullable: false),
                    ID_BODEGA = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__USUARIO__91136B9039C79A3A", x => x.ID_USUARIO);
                    table.ForeignKey(
                        name: "FK_USUARIO_BODEGA_ID_BODEGA",
                        column: x => x.ID_BODEGA,
                        principalTable: "BODEGA",
                        principalColumn: "ID_BODEGA",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KILOMETROS",
                columns: table => new
                {
                    ID_KILOMETRO_DIARIO = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ID_MOVIL = table.Column<int>(type: "int", nullable: false),
                    FECHA_REGISTRO = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KILOMETRO = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KILOMETROS", x => x.ID_KILOMETRO_DIARIO);
                    table.ForeignKey(
                        name: "FK_KILOMETROS_MOVIL_ID_MOVIL",
                        column: x => x.ID_MOVIL,
                        principalTable: "MOVIL",
                        principalColumn: "ID_MOVIL");
                });

            migrationBuilder.CreateTable(
                name: "NEUMATICOS",
                columns: table => new
                {
                    ID_NEUMATICO = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CODIGO = table.Column<int>(type: "int", nullable: false),
                    UBICACION = table.Column<string>(type: "char(50)", unicode: false, fixedLength: true, maxLength: 50, nullable: true),
                    MOVIL_ASIGNADO = table.Column<int>(type: "int", nullable: true),
                    ID_BODEGA = table.Column<int>(type: "int", nullable: false),
                    FECHA_INGRESO = table.Column<DateTime>(type: "datetime2", nullable: false),
                    FECHA_SALIDA = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ESTADO = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    KM_TOTAL = table.Column<int>(type: "int", nullable: false),
                    TIPO_NEUMATICO = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__NEUMATIC__BEA984E3CB53E60C", x => x.ID_NEUMATICO);
                    table.ForeignKey(
                        name: "FK_NEUMATICOS_BODEGA_ID_BODEGA",
                        column: x => x.ID_BODEGA,
                        principalTable: "BODEGA",
                        principalColumn: "ID_BODEGA");
                    table.ForeignKey(
                        name: "FK_NEUMATICOS_MOVIL_MOVIL_ASIGNADO",
                        column: x => x.MOVIL_ASIGNADO,
                        principalTable: "MOVIL",
                        principalColumn: "ID_MOVIL",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateIndex(
                name: "IX_KILOMETROS_ID_MOVIL",
                table: "KILOMETROS",
                column: "ID_MOVIL");

            migrationBuilder.CreateIndex(
                name: "IX_MOVIL_ID_BODEGA",
                table: "MOVIL",
                column: "ID_BODEGA");

            migrationBuilder.CreateIndex(
                name: "IX_NEUMATICOS_ID_BODEGA",
                table: "NEUMATICOS",
                column: "ID_BODEGA");

            migrationBuilder.CreateIndex(
                name: "IX_NEUMATICOS_MOVIL_ASIGNADO",
                table: "NEUMATICOS",
                column: "MOVIL_ASIGNADO");

            migrationBuilder.CreateIndex(
                name: "IX_USUARIO_ID_BODEGA",
                table: "USUARIO",
                column: "ID_BODEGA");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "KILOMETROS");

            migrationBuilder.DropTable(
                name: "NEUMATICOS");

            migrationBuilder.DropTable(
                name: "TABLA");

            migrationBuilder.DropTable(
                name: "USUARIO");

            migrationBuilder.DropTable(
                name: "MOVIL");

            migrationBuilder.DropTable(
                name: "BODEGA");
        }
    }
}
