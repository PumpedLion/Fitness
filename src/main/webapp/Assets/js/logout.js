// Create and append the modal HTML
document.addEventListener('DOMContentLoaded', function() {
    const modalHTML = `
        <div id="logoutModal" class="modal" style="display: none;">
            <div class="modal-content">
                <h2>Confirm Logout</h2>
                <p>Are you sure you want to logout?</p>
                <div class="modal-buttons">
                    <button onclick="confirmLogout()" class="confirm-btn">Yes, Logout</button>
                    <button onclick="closeLogoutModal()" class="cancel-btn">Cancel</button>
                </div>
            </div>
        </div>
    `;
    document.body.insertAdjacentHTML('beforeend', modalHTML);

    // Add modal styles
    const modalStyles = `
        <style>
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
            }

            .modal-content {
                background-color: #1E293B;
                margin: 15% auto;
                padding: 20px;
                border: 1px solid #334155;
                border-radius: 8px;
                width: 300px;
                text-align: center;
                color: white;
            }

            .modal-buttons {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                gap: 10px;
            }

            .confirm-btn {
                background-color: #EF4444;
                color: white;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .confirm-btn:hover {
                background-color: #DC2626;
            }

            .cancel-btn {
                background-color: #334155;
                color: white;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .cancel-btn:hover {
                background-color: #475569;
            }
        </style>
    `;
    document.head.insertAdjacentHTML('beforeend', modalStyles);
});

// Show the logout modal
function showLogoutModal() {
    document.getElementById('logoutModal').style.display = 'block';
}

// Close the logout modal
function closeLogoutModal() {
    document.getElementById('logoutModal').style.display = 'none';
}

// Handle logout confirmation
function confirmLogout() {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/UserLogoutServlet';
    document.body.appendChild(form);
    form.submit();
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('logoutModal');
    if (event.target == modal) {
        closeLogoutModal();
    }
} 