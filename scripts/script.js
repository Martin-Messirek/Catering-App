const dialogBg = document.getElementById('dialog-bg');
const listDialog = document.getElementById("list-dialog");

function openDialog() {
    dialogBg.classList.remove('d-none');
    listDialog.classList.remove('d-none');
}

function closeDialog() {
    dialogBg.classList.add('d-none');
    listDialog.classList.add('d-none');
}
