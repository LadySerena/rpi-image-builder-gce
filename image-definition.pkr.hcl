source "googlecompute" "pi-image-builder" {
  project_id = "telvanni-platform"
  source_image_family = "tel-base-debian-11"
  zone = "us-central1-a"
  image_name = "rpi-builder-${var.tag_name}"
  image_description = "machine image that has the tools needed to build raspberry pi images"
  image_family = "rbi-builder"
  image_storage_locations = [
    "us"]
  preemptible = true
  ssh_username = "packer"
  disk_size = 20
  disk_type = "pd-ssd"
}

build {
  sources = [
    "source.googlecompute.pi-image-builder"]

  provisioner "file" {
    destination = "/tmp/compress.bash"
    source = "./compress.bash"
  }

  provisioner "file" {
    destination = "/tmp/install.bash"
    source = "./install.bash"
  }

  provisioner "file" {
    destination = "/tmp/setup.bash"
    source = "./setup.bash"
  }

  provisioner "ansible-local" {
    extra_arguments = [
      "--extra-vars",
      "ansible_python_interpreter=/usr/bin/python3"]
    playbook_file = "tools-install.yaml"
  }
}
