@tool
extends EditorPlugin

var import_plugin

func _enter_tree() -> void:
	import_plugin = AutoCropImporter.new()
	add_import_plugin(import_plugin)

func _exit_tree() -> void:
	remove_import_plugin(import_plugin)
	import_plugin = null

# Internal class handling the actual image cropping
class AutoCropImporter extends EditorImportPlugin:

	func _get_importer_name() -> String:
		return "custom.autocrop"

	func _get_visible_name() -> String:
		return "Auto Crop Texture"

	func _get_recognized_extensions() -> PackedStringArray:
		return PackedStringArray(["png"])

	func _get_save_extension() -> String:
		return "res"

	func _get_resource_type() -> String:
		return "ImageTexture"

	func _get_preset_count() -> int:
		return 0

	func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
		return []

	func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
		return true

	func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
		print("-- AutoCropImporter: _import, source_file ", source_file, ", save_path ", save_path, ", options ", options, ", flatform_variants", platform_variants )
		var img := Image.load_from_file(source_file)
		if not img:
			return ERR_CANT_OPEN

		var rect := img.get_used_rect()
		var offset := Vector2.ZERO
		
		if rect.has_area() and rect.size != img.get_size():
			# offset = rect.position
			img = img.get_region(rect)
			
		var texture := ImageTexture.create_from_image(img)
		# texture.set_meta("crop_offset", offset)

		# Save the processed image as a Godot texture resource
		var filename := "%s.%s" % [save_path, _get_save_extension()]
		print("filename ", filename)
		return ResourceSaver.save(texture, filename)
		
	# Generates the thumbnail preview displayed in the FileSystem dock
	func _import_thumbnail(source_file: String, save_path: String, options: Dictionary) -> String:
		print("AutoCropImporter: _import_thumbnail, source_file ", source_file, ", save_path ", save_path, ", options ", options)
		# Load the original image
		var img := Image.load_from_file(source_file)
		if not img:
			return ""

		# Replicate the exact same cropping logic so the thumbnail matches the asset
		var rect := img.get_used_rect()
		if rect.has_area() and rect.size != img.get_size():
			img = img.get_region(rect)

		# Downscale large textures so they fit standard editor preview sizes efficiently
		# (Godot previews are typically 128x128 pixels max)
		if img.get_width() > 128 or img.get_height() > 128:
			img.resize(128, 128, Image.INTERPOLATE_LANCZOS)

		# Save the preview file inside Godot's internal cache path
		var thumb_path := "%s.png" % save_path
		var err := img.save_png(thumb_path)
	
		if err == OK:
			print("success thumbnail path", thumb_path)
			return thumb_path # Return the path so the editor knows where to grab it
		return ""
