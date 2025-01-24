using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_control_neumaticos.Migrations
{
    /// <inheritdoc />
    public partial class CambioUbicacionToInt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "UBICACION",
                table: "NEUMATICOS",
                type: "int",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "char(50)",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "TIPO_NEUMATICO",
                table: "NEUMATICOS",
                type: "int",
                unicode: false,
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(50)",
                oldUnicode: false,
                oldMaxLength: 50);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "UBICACION",
                table: "NEUMATICOS",
                type: "char(50)",
                unicode: false,
                fixedLength: true,
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int",
                oldUnicode: false,
                oldFixedLength: true,
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "TIPO_NEUMATICO",
                table: "NEUMATICOS",
                type: "varchar(50)",
                unicode: false,
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int",
                oldUnicode: false,
                oldMaxLength: 50);
        }
    }
}
