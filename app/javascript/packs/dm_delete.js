function messageDelete() {
  const messages = document.querySelectorAll('.room-list-text')
  const deleteLink = document.querySelectorAll('.message-delete-btn')
  messages.forEach(function (message) {
    message.addEventListener('mouseover', () => {
      deleteLink.forEach(function (link) {
        link.innerHTML =  `
         <i class="far fa-trash-alt message-trash"></i> 削除`
      });
      deleteLink.forEach(function (link) {
        link.addEventListener('mouseout', () => {
          link.innerHTML = ''
        });
      });
    });
  });
};
window.addEventListener('load', messageDelete);