document.addEventListener('DOMContentLoaded', () => {
    // Handle edit phone button click
    document.querySelectorAll('.edit-phone-btn').forEach(button => {
        button.addEventListener('click', function() {
            const username = this.getAttribute('data-username');
            const row = document.getElementById(`user-${username}`);
            row.querySelector('.phone-number').style.display = 'none';
            row.querySelector('.edit-phone').style.display = 'inline';
            row.querySelector('.save-phone-btn').style.display = 'inline';
            this.style.display = 'none';
        });
    });

    // Handle save phone button click
    document.querySelectorAll('.save-phone-btn').forEach(button => {
        button.addEventListener('click', async function() {
            const username = this.getAttribute('data-username');
            const phone = document.querySelector(`#user-${username} .edit-phone`).value;

            const response = await fetch('/admin/updatephone', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, phone })
            });

            if (response.ok) {
                const data = await response.json();
                alert(data.message);
                location.reload(); // Refresh the page to see updated data
            } else {
                alert('Error updating phone number');
            }
        });
    });

    // Handle edit role button click
    document.querySelectorAll('.edit-role-btn').forEach(button => {
        button.addEventListener('click', function() {
            const username = this.getAttribute('data-username');
            const row = document.getElementById(`user-${username}`);
            row.querySelector('.user-role').style.display = 'none';
            row.querySelector('.edit-role').style.display = 'inline';
            row.querySelector('.save-role-btn').style.display = 'inline';
            this.style.display = 'none';
        });
    });

    // Handle save role button click
    document.querySelectorAll('.save-role-btn').forEach(button => {
        button.addEventListener('click', async function() {
            const username = this.getAttribute('data-username');
            const role = document.querySelector(`#user-${username} .edit-role`).value;

            const response = await fetch('/admin/updaterole', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username, isAdmin: role === 'true' })
            });

            if (response.ok) {
                const data = await response.json();
                alert(data.message);
                location.reload(); // Refresh the page to see updated data
            } else {
                alert('Error updating role');
            }
        });
    });
});
