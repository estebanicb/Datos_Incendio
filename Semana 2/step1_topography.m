%% PASO 1: PROCESAMIENTO DE TOPOGRAFÍA
% Objetivo: Leer GeoTIFF y crear mallas X, Y, Z para la simulación
clear; clc; close all;

% 1. Configuración
filename = '../data/raw/dem_castellvi.tif'; % Ajusta la ruta si es necesario

% 2. Leer el archivo GeoTIFF
% Z = Matriz de elevaciones (Altura)
% R = Referencia espacial (Coordenadas)
try
    [Z, R] = readgeoraster(filename);
    disp('✅ Archivo GeoTIFF leído correctamente.');
catch ME
    error('❌ Error leyendo el TIF. Verifica la ruta o instala Mapping Toolbox.');
end

% 3. Generar matrices de coordenadas (Meshgrid)
% Esto crea una matriz X y una Y para cada píxel de Z
[rows, cols] = size(Z);
[X, Y] = worldGrid(R, [rows, cols]); % Función auxiliar de mapeo (o pixcenters)

% Si worldGrid no existe en tu versión, usamos pixcenters:
if isempty(X)
    [lat, lon] = pixcenters(R, rows, cols);
    [X, Y] = meshgrid(lon, lat);
end

% 4. Visualización 3D (Control de Calidad)
figure('Name', 'Dominio de Simulación', 'Color', 'w');
surf(X, Y, Z); 
shading interp; % Suaviza los colores
colormap terrain; 
colorbar;
axis tight; 
view(3); % Vista 3D
title('Dominio Topográfico: Castellví de Rosanes');
xlabel('Longitud / X');
ylabel('Latitud / Y');
zlabel('Elevación (m)');

% Luz para ver el relieve mejor (Hillshade effect)
camlight; lighting gouraud;

% 5. Guardar en formato .mat
save('../data/processed/topography.mat', 'X', 'Y', 'Z', 'R');
disp('💾 Datos guardados en data/processed/topography.mat');