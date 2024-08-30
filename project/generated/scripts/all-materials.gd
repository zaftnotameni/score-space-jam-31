class_name Gen_AllMaterials extends Node
const MATERIAL_LAVA : ShaderMaterial = preload("res://generated/materials/lava_material.tres")
const MATERIAL_PIXEL_PERFECT_DISSOLVE_SHADER : ShaderMaterial = preload("res://generated/materials/pixel-perfect-dissolve-shader_material.tres")
const MATERIAL_SQUARES_SCREEN_TRANSITION_SHADER : ShaderMaterial = preload("res://generated/materials/squares-screen-transition-shader_material.tres")

var ALL_MATERIALS := [MATERIAL_LAVA,MATERIAL_PIXEL_PERFECT_DISSOLVE_SHADER,MATERIAL_SQUARES_SCREEN_TRANSITION_SHADER,]
