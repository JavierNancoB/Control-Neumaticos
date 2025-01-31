﻿using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace api_control_neumaticos.Models;

public partial class ControlNeumaticosContext : DbContext
{
    public ControlNeumaticosContext(DbContextOptions<ControlNeumaticosContext> options)
        : base(options)
    {
    }
    public virtual DbSet<Movil> Movils { get; set; }

    public virtual DbSet<Neumatico> Neumaticos { get; set; }

    public virtual DbSet<Tabla> Tablas { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    public virtual DbSet<Bodega> Bodegas { get; set; }

    public DbSet<Kilometros> Kilometros { get; set; }

    public DbSet<Alerta> Alertas { get; set; }

    public DbSet<HistorialNeumatico> HistorialesNeumaticos { get; set; }

    public DbSet<Bitacora> Bitacoras { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Movil>(entity =>
        {
            entity.HasKey(e => e.IdMovil).HasName("PK__MOVIL__CEA90288602B00B0");

            entity.ToTable("MOVIL");

            entity.Property(e => e.IdMovil).HasColumnName("ID_MOVIL");
            entity.Property(e => e.Patente)
                .HasMaxLength(6)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("PATENTE");
            entity.Property(e => e.Marca)
                .HasMaxLength(50)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MARCA");
            entity.Property(e => e.Modelo)
                .HasMaxLength(50)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("MODELO");
            entity.Property(e => e.Ejes).HasColumnName("EJES");
            entity.Property(e => e.TipoMovil).HasColumnName("TIPO_MOVIL");
            entity.Property(e => e.CantidadNeumaticos).HasColumnName("CANTIDAD_NEUMATICOS");
            entity.Property(e => e.Estado)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ESTADO");
            
            entity.Property(e => e.ID_BODEGA).HasColumnName("ID_BODEGA");

            // Relación con Bodega
            entity.HasOne(m => m.Bodega)
                .WithMany()
                .HasForeignKey(m => m.ID_BODEGA)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<Neumatico>(entity =>
        {
            entity.HasKey(e => e.ID_NEUMATICO).HasName("PK__NEUMATIC__BEA984E3CB53E60C");

            entity.ToTable("NEUMATICOS");

            entity.Property(e => e.ID_NEUMATICO).HasColumnName("ID_NEUMATICO");
            entity.Property(e => e.CODIGO).HasColumnName("CODIGO");
            entity.Property(e => e.ID_MOVIL).HasColumnName("MOVIL_ASIGNADO");
            entity.Property(e => e.UBICACION)
                .HasMaxLength(50)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("UBICACION");
            entity.Property(e => e.ID_BODEGA).HasColumnName("ID_BODEGA");
            entity.Property(e => e.FECHA_INGRESO).HasColumnName("FECHA_INGRESO");
            entity.Property(e => e.FECHA_SALIDA).HasColumnName("FECHA_SALIDA");
            entity.Property(e => e.ESTADO)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ESTADO");
            entity.Property(e => e.KM_TOTAL).HasColumnName("KM_TOTAL");
            entity.Property(e => e.TIPO_NEUMATICO)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("TIPO_NEUMATICO");

            // Relación con la entidad Movil
            entity.HasOne(n => n.MOVIL_ASIGNADO)
                .WithMany()
                .HasForeignKey(n => n.ID_MOVIL)
                .OnDelete(DeleteBehavior.SetNull);

            // Relación con la entidad Bodega
            entity.HasOne(n => n.BODEGA)
                .WithMany()
                .HasForeignKey(n => n.ID_BODEGA)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<Bodega>(entity =>
        {
            entity.HasKey(e => e.ID_BODEGA).HasName("PK__BODEGA__3F5C45522D15E7A1");

            entity.ToTable("BODEGA");

            entity.Property(e => e.ID_BODEGA).HasColumnName("ID_BODEGA");
            entity.Property(e => e.NOMBRE_BODEGA)
                .HasMaxLength(100)
                .IsUnicode(true)
                .HasColumnName("NOMBRE_BODEGA");
        });

        modelBuilder.Entity<Tabla>(entity =>
        {
            entity.HasKey(e => new { e.CodTabla, e.Codigo }).HasName("PK__TABLA__B22008D28B9CFED8");

            entity.ToTable("TABLA");

            entity.Property(e => e.CodTabla).HasColumnName("COD_TABLA");
            entity.Property(e => e.Codigo).HasColumnName("CODIGO");
            entity.Property(e => e.Descripcion)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("DESCRIPCION");
            entity.Property(e => e.Estado).HasColumnName("ESTADO");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.IdUsuario).HasName("PK__USUARIO__91136B9039C79A3A");

            entity.ToTable("USUARIO");

            entity.Property(e => e.IdUsuario).HasColumnName("ID_USUARIO");
            entity.Property(e => e.Apellidos)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("APELLIDOS");
            entity.Property(e => e.Clave)
                .HasMaxLength(255)
                .HasColumnName("CLAVE");
            entity.Property(e => e.CodEstado).HasColumnName("COD_ESTADO");
            entity.Property(e => e.CodigoPerfil).HasColumnName("CODIGO_PERFIL");
            entity.Property(e => e.Correo)
                .HasMaxLength(320)
                .HasColumnName("CORREO");
            entity.Property(e => e.Nombres)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("NOMBRES");
        });

        modelBuilder.Entity<Kilometros>(entity =>
        {
            entity.ToTable("KILOMETROS");
            entity.HasKey(e => e.ID_KILOMETRO_DIARIO);
            entity.Property(e => e.FECHA_REGISTRO).IsRequired();
            entity.Property(e => e.KILOMETRO).IsRequired();

            entity.HasOne(e => e.Movil)
                .WithMany()
                .HasForeignKey(e => e.ID_MOVIL)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });
        
        modelBuilder.Entity<Alerta>(entity =>
        {
            entity.ToTable("ALERTA");

            entity.HasKey(e => e.Id).HasName("PK__ALERTA__3214EC07");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.ID_NEUMATICO).HasColumnName("ID_NEUMATICO");
            entity.Property(e => e.USUARIO_LEIDO_ID).HasColumnName("ID_USUARIO_LEIDO");
            entity.Property(e => e.USUARIO_ATENDIDO_ID).HasColumnName("ID_USUARIO_ATENDIDO");
            entity.Property(e => e.FECHA_INGRESO)
                .IsRequired()
                .HasColumnName("FECHA_INGRESO");
            entity.Property(e => e.FECHA_LEIDO)
                .HasColumnName("FECHA_LEIDO");
            entity.Property(e => e.FECHA_ATENDIDO)
                .HasColumnName("FECHA_ATENDIDO");
            entity.Property(e => e.ESTADO_ALERTA).IsRequired()
                .HasColumnName("ESTADO_ALERTA");
            entity.Property(e => e.CODIGO_ALERTA).IsRequired()
                .HasColumnName("CODIGO_ALERTA");

            entity.HasOne(e => e.Neumatico)
                .WithMany()
                .HasForeignKey(e => e.ID_NEUMATICO)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<HistorialNeumatico>(entity =>
        {
            entity.ToTable("HISTORIAL_NEUMATICO");
            entity.HasKey(e => e.ID);
            entity.Property(e => e.FECHA).IsRequired();
            entity.Property(e => e.CODIGO).IsRequired();
            entity.Property(e => e.ESTADO).IsRequired();
            entity.Property(e => e.OBSERVACION).IsRequired();

            entity.Property(e => e.IDNeumatico).HasColumnName("ID_NEUMATICO");
            entity.Property(e => e.IDUsuario).HasColumnName("ID_USUARIO");

            entity.HasOne(e => e.Neumatico)
            .WithMany()
            .HasForeignKey(e => e.IDNeumatico)
            .OnDelete(DeleteBehavior.ClientSetNull);

            entity.HasOne(e => e.Usuario)
            .WithMany()
            .HasForeignKey(e => e.IDUsuario)
            .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<Bitacora>(entity =>
        {
            entity.ToTable("BITACORA");
            
            entity.HasKey(e => e.ID).HasName("PK__BITACORA__3214EC07");

            entity.Property(e => e.ID).HasColumnName("ID");
            entity.Property(e => e.CODIGO).HasColumnName("CODIGO");
            entity.Property(e => e.ID_OBJETO).HasColumnName("ID_OBJETO");
            entity.Property(e => e.TIPO_OBJETO)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("TIPO_OBJETO");
            entity.Property(e => e.ID_USUARIO).HasColumnName("ID_USUARIO");
            entity.Property(e => e.FECHA).HasColumnName("FECHA");
            entity.Property(e => e.OBSERVACION)
                .HasMaxLength(500)
                .IsUnicode(true)
                .HasColumnName("OBSERVACION");
            entity.Property(e => e.ESTADO)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ESTADO");

            // Relación con Usuario
            entity.HasOne(b => b.Usuario)
                .WithMany()
                .HasForeignKey(b => b.ID_USUARIO)
                .OnDelete(DeleteBehavior.Restrict); // Evitar que se borre el usuario si existe en Bitacora

            // Relación dinámica con Neumatico, Movil o Usuario dependiendo del tipo de objeto
            entity.HasOne(b => b.Neumatico)
                .WithMany()
                .HasForeignKey(b => b.ID_OBJETO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Bitacora_Neumatico")
                .IsRequired(false); // Este campo será null si TIPO_OBJETO es diferente

            entity.HasOne(b => b.Movil)
                .WithMany()
                .HasForeignKey(b => b.ID_OBJETO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Bitacora_Movil")
                .IsRequired(false); // Este campo será null si TIPO_OBJETO es diferente

            entity.HasOne(b => b.Usuario)
                .WithMany()
                .HasForeignKey(b => b.ID_OBJETO)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Bitacora_Usuario")
                .IsRequired(false); // Este campo será null si TIPO_OBJETO es diferente
        });



    }
}
